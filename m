Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2ITKPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:15:47 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:33605 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab2ITKPq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:15:46 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 20 Sep 2012 12:15:23 +0200
Subject: RE: [PATCHv3] remoteproc: Add STE modem driver for remoteproc
Thread-Topic: [PATCHv3] remoteproc: Add STE modem driver for remoteproc
Thread-Index: Ac2XF+8AxhMWmFeaTtmJAHDeNgTmNwAACZcg
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BD6DF2F0@EXDCVYMBSTM005.EQ1STM.local>
References: <1348072769-17314-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYt1mtDSyTQzOxO+mcp320A3MQrgXuL=AY7h9FixSg=hg@mail.gmail.com>
In-Reply-To: <CAK=WgbYt1mtDSyTQzOxO+mcp320A3MQrgXuL=AY7h9FixSg=hg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> > +       /* Provide callbacks to modem device */
> > +       mdev->drv_ops = &sproc_drv_ops;
> 
> Implicitly providing the modem with drv_ops and drv_data in this
> manner feels racy and somewhat error prone.
> 
> E.g., on remove these members are set to NULL, under the assumption
> that the modem won't invoke sproc_kick_callback or access sproc
> anymore, but this doesn't feel safe.
> 
> Any chance you can add an explicit registration method to
> ste_modem_dev_ops, with which you'll be able to explicitly set/unset
> sproc_kick_callback and sproc ?

Good point. I'll make a respin fixing this.

Thanks,
Sjur
