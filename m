Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1HRTPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:15:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab1HRTPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:15:42 -0400
Subject: Re: [PATCH] ath9k: make driver usable standalone
From: Dan Williams <dcbw@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
        Pavel Ivanov <paivanof@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Aug 2011 14:18:09 -0500
In-Reply-To: <24649.1313621503@turing-police.cc.vt.edu>
References: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
	 <CA+XFjipM1Qup3bcJos_ikwzoaWoa3GdYqK0WBUqEHBNR6V6LfQ@mail.gmail.com>
	 <CAG1a4rsyfPrrrf-mzt3HAM6YHHjaHTcd2rbtYiwqLkUCP=j8pQ@mail.gmail.com>
	 <CA+XFjipsVukKYchfmDv48PAKsD2PUxT+7E8epRuKFynGwk=Bag@mail.gmail.com>
	 <24649.1313621503@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1313695090.23920.2.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 18:51 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 17 Aug 2011 18:25:49 +0200, Gábor Stefanik said:
> 
> > Iwconfig and iwlist are themselves deprecated. Iw is the new wireless
> > configuration tool.
> 
> Somebody better tell Fedora Rawhide - as of the version released on July 27,
> their 'initscripts' RPM was still using iwconfig in /etc/sysconfig/network-scripts/ifup-wireless
> 
> So don't be quite so fast to be declaring WIRELESS_EXT dead just yet.

Given that nobody has stepped up to write patches to convert them to use
iw (or wpa_supplicant in the *correct* manner), and that for the most
part wifi on Fedora goes through NetworkManager and/or wpa_supplicant,
it's not surprising.  I don't have any particular interest in keeping
the existing ifup-wireless iwconfig hackery around, instead if it's
converted at all, it should be converted to use wpa_supplicant instead,
in the manner in which I've described in the various bug reports that
keep coming up.  That means not just pointing wpa_supplicant at a config
file, but instead keeping the options in the ifcfg file and writing out
a temporary wpa_supplicant config on-the-fly so that it integrates with
existing administrator expectations and workflow.

Dan

