Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2GBOAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:00:42 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:19853 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2GBOAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:00:41 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=0ZxBYtrx0jjMZyuN3SCpZ7oeUJtVROPSSKxUTr2DTNaQL8G7howKsOPq4BoS
	3j/pISc9BteHQ/hgwCDvi57PobW1eKW7cbGv2mdTsW1C+O4XrgcsXSJJJ
	MVuuiuc/KTwiGUKw/b0vlAprbGY1feUFHcUBWYvGmdbSrnyrRmC+9I=;
X-Spam-Processed: mail.digidescorp.com, Mon, 02 Jul 2012 09:00:40 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1530ba36e9=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341237638.1695.16.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] fat: Refactor shortname parsing
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 09:00:38 -0500
In-Reply-To: <87fw9anuwk.fsf@devron.myhome.or.jp>
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	 <87r4syrl4y.fsf@devron.myhome.or.jp>
	 <1340997235.9826.7.camel@iscandar.digidescorp.com>
	 <87bok1sx6j.fsf@devron.myhome.or.jp> <87zk7lribe.fsf@devron.myhome.or.jp>
	 <1341234099.1695.13.camel@iscandar.digidescorp.com>
	 <87fw9anuwk.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 22:40 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > On Sat, 2012-06-30 at 05:09 +0900, OGAWA Hirofumi wrote: 
> >> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> >> 
> >> >
> >> > 			if (is_vfat)
> >> > 				ptname[i++] = fat_tolower(!nocase, c);
> >> 
> >> Of course, if (!is_vfat). Sorry.
> >
> > I agree that the nocase logic is confusing, but I'm pretty sure this
> > change would break the code. 
> 
> I might be wrong here though, which place is broken with it?
> 
> > 'nocase' is always zero for vfat, which does not recognize that option.
> > For msdos, it is zero by default, and 1 if the 'nocase' option was
> > specified.
> > In all cases it is necessary to copy *something* to ptname.
> 
> Looks like, we overwrite bufname by converted bufuname in is_vfat case?
> 
> 	if (isvfat) {
> 		bufuname[j] = 0x0000;
> 		i = fat_uni_to_x8(sb, bufuname, bufname, sizeof(bufname));
> 	}

True, but with the change you suggest we lose the incrementing of 'i',
which likely would cause an infinite loop for 1:1 Unicode conversions.

Steve


