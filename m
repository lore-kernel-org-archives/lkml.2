Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2GBNKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:10:23 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:10775 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2GBNKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:10:22 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2012 09:10:22 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=Bn62I/Bz0j7ZvXCyeVgWmUG5oZeFtLUPCz0klxJdtd94ilbErkuhEwIjD1PU
	It+PiFJNTq6NQPyiZa69A5JD0tdyZ4nCRKVV/Uxz/U/90G9AwTfrDKx2x
	vNuJ4qi8Ku/fPKq6Q/4i8V8xJcf3J9jmPT0lRv42XhQNEB+Oz2jYCY=;
X-Spam-Processed: mail.digidescorp.com, Mon, 02 Jul 2012 08:01:43 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1530ba36e9=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341234099.1695.13.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] fat: Refactor shortname parsing
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 08:01:39 -0500
In-Reply-To: <87zk7lribe.fsf@devron.myhome.or.jp>
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	 <87r4syrl4y.fsf@devron.myhome.or.jp>
	 <1340997235.9826.7.camel@iscandar.digidescorp.com>
	 <87bok1sx6j.fsf@devron.myhome.or.jp> <87zk7lribe.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-30 at 05:09 +0900, OGAWA Hirofumi wrote: 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> >
> > 			if (is_vfat)
> > 				ptname[i++] = fat_tolower(!nocase, c);
> 
> Of course, if (!is_vfat). Sorry.

I agree that the nocase logic is confusing, but I'm pretty sure this
change would break the code. 

'nocase' is always zero for vfat, which does not recognize that option.
For msdos, it is zero by default, and 1 if the 'nocase' option was
specified.
In all cases it is necessary to copy *something* to ptname.

What could be done is something like this:

if (nocase)
ptname[i++] = c;
else
ptname[i++] = fat_tolower(c);

or, if you don't mind trigraphs:
ptname[i++] = nocase ? c : fat_tolower(c);

Let me know what you prefer.

Thanks,
Steve


