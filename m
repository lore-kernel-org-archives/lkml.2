Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2GBOps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:45:48 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:31872 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2GBOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:45:47 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=1IKncLGdTowz0MbGTOWUgENIkQpQJS/TcwN95xpRkZgTS0ZUu61if/f7k7Y1
	yMmsG7TeWyqMzi9lvRI2GT5jsdTirME+oDjM6r45IKhUMkQ382vGVInpC
	Bs0Hlt88GcmmuSp5YteVoYwZRyePrXd3oCupnNFt2fHDQzqNaCMHFY=;
X-Spam-Processed: mail.digidescorp.com, Mon, 02 Jul 2012 09:45:45 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1530ba36e9=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341240342.1695.20.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] fat: Refactor shortname parsing
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 09:45:42 -0500
In-Reply-To: <8762a6nsao.fsf@devron.myhome.or.jp>
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	 <87r4syrl4y.fsf@devron.myhome.or.jp>
	 <1340997235.9826.7.camel@iscandar.digidescorp.com>
	 <87bok1sx6j.fsf@devron.myhome.or.jp> <87zk7lribe.fsf@devron.myhome.or.jp>
	 <1341234099.1695.13.camel@iscandar.digidescorp.com>
	 <87fw9anuwk.fsf@devron.myhome.or.jp>
	 <1341237638.1695.16.camel@iscandar.digidescorp.com>
	 <8762a6nsao.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 23:36 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > True, but with the change you suggest we lose the incrementing of 'i',
> > which likely would cause an infinite loop for 1:1 Unicode conversions.
> 
> You meant, we just have to do
> 
> 	if (!is_vfat)
>         	ptname[i] = ...;
> 	i++;
> 
> or something? I still feel this looks better to indicate, we don't use
> ptname in the case of vfat.

I can change it, but there are other places in that function where
ptname is used that are not qualified with !is_vfat, so I don't know
whether this improves clarity or reduces it.

I do think fat_tolower() should not be making decisions. IMHO the
trigraph and a comment, perhaps before the vfat-only reassignment of
'name', would be clearer. 

Steve


