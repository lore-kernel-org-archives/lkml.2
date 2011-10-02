Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1JBMJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 08:09:24 -0400
Received: from nm36-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.119]:33162 "HELO
	nm36-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752304Ab1JBMJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 08:09:16 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Oct 2011 08:09:16 EDT
X-Yahoo-Newman-Id: 471538.75317.bm@smtp115.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BpIbw8kVM1lMcrf.CJRQ3.0X43K1LjD_gKyBR4ujQJhPu4o
 n6GBTnEvTnwPcpFhrjTkTqp5q0U2i5l15NFTEIy63bXv7tcFz7COELp95oJo
 adcu0z4VvCfqB4QA5.HVPqYtS0XFwUfkC1S1XT4EdgDb.809gdpgUYFiJvJC
 xc2KDP8zrm2nhF6V1CNS4Cf_zMS1KfMZE588NWqzDIy662hEOFL7.Yt.oRKy
 r5MA70jQknbJxZWomRy.S7mOuyxd1vUd.Z61MgHfM6av9qc7HkhUR3EmN_g.
 Em9K9Q965PQxye9jkmdQhdkkzHMh50WSyGPHKzdi5srHH4yGzMSdWxN_A0Pn
 Baqsy5VUVjjFhc54ZqJxJ1a7QuRq1BCcsWVbih1DKwQAElv2nsszMVxy8cZ1
 u1TI.FO7jjFJoHoizhVClDoYzYHk1khGxxSsPq9i8MTP5Rpy4ySl1Mmh7.K2
 0uODWfMdVLo9PbMjix6X6P0QBdTc4XUUzZNYsoGLSJ7ccpdihdgq8CPsfBhq
 xE_Cv
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Sun, 2 Oct 2011 07:03:52 -0500
From: Andy <akwatts@ymail.com>
To: Greg KH <greg@kroah.com>
Cc: tmhikaru@gmail.com, Willy Tarreau <w@1wt.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hpa@zytor.com
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111002120352.GA26850@zeus>
References: <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
 <20111001142848.GA27058@kroah.com>
 <20111001165659.GB18690@1wt.eu>
 <20111001171916.GA11989@zeus>
 <20111001175456.GC18690@1wt.eu>
 <20111001184044.GA13608@zeus>
 <20111002022643.GA4076@kroah.com>
 <20111002033058.GA20166@zeus>
 <20111002043948.GA6934@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111002043948.GA6934@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:39:48PM -0700, Greg KH wrote:
> I've did this a while ago when we were working on verifying the
> tarballs, here's what I got, one column is with the umask unset, and the
> other set to 022, both of them being the sha256sum output.

Thank you very much for posting that information.

> If this isn't sufficient, just give me a script I can run and I'll be
> glad to provide the numbers.

Many of us would benefit from having signatures for some of the recent
kernels missing for your list as well as Willy's. For example, a few
systems of mine run 2.6.39.4 due to sleep-related issues with 3.0.x+ and
those hardware platforms.

It would be great to have fingerprints for:

2.6.35.1 - 2.6.35.9 (2.6.35.14?)
2.6.36.1 - 2.6.36.4
2.6.37.1 - 2.6.37.6
2.6.38.1 - 2.6.38.8
2.6.39.1 - 2.6.39.4

Here is a script (based on Willy's) to use inside the git dirs:

for mask in 002 022
do
  git config tar.umask $mask
  echo "umask set to: $mask"
  for tag in $(git tag | grep "^v[23]" | egrep -v 'pre|rc|tree')
  do
    echo -ne "${tag#v}\t"
    git archive --format tar --prefix linux-${tag#v}/ $tag | sha256sum
  done
  echo
done  

Many thanks,

~ Andy

