Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab2K0JBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:01:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab2K0JBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:01:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: new warnings from partial __devexit removal
Date: Tue, 27 Nov 2012 09:01:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201211262038.32276.arnd@arndb.de> <20121126225056.GB28995@kroah.com>
In-Reply-To: <20121126225056.GB28995@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211270901.33531.arnd@arndb.de>
X-Provags-ID: V02:K0:Guf0wf2xiEO4+hTg6WIg16aT6Nsyp92Oobh45IEp5yv
 todqQ2MO03YaHYlzbOma+6DfiHVBGWV6lCbub0pNNRuW3GCb4I
 gFI7r/5gJC94SN6MpMxmimXGGl+x5wcKbIKlYK3Qh7ZNgZZZ7C
 zIjsDFbPHdnEE3UVpjWScYqYcL1dPzBhgVgvnwTV4V40pc3zDx
 mdF+6F+vs3EC68Lbb0/FyxB/xx6HvNTQLDxNdIG3Ar3CAuY0q8
 hH0nw41TW8VrjVwYn1hSsDJG6EPlnyGXoUauvZ3lesXAt4ZO/V
 HImz/ahKTJijIqmsOwO9Yl4DttjfU+cAALnCRk0wy36C8tqAne
 XhtSDEOwIrbD8iH+Mr68=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 November 2012, gregkh@linuxfoundation.org wrote:
> On Mon, Nov 26, 2012 at 08:38:32PM +0000, Arnd Bergmann wrote:
> > This is probably known and fixed already, but in case it's not, let me just
> > mention that I saw two new warnings with ARM allyesconfig about a
> > __devexit being removed but the __devexit_p() still being there:
> > 
> > drivers/tty/serial/xilinx_uartps.c:1000:12: error: 'xuartps_remove' defined but not used [-Werror=unused-function]
> > drivers/usb/gadget/mv_udc_core.c:2131:12: error: 'mv_udc_remove' defined but not used [-Werror=unused-function]
> 
> What platform has -Werror=unused-function set?

My test script to check if any new warnings have come in sets -Werror.

I have a git branch that has workarounds for all known gcc warnings on ARM, so
one of my tests after merging stuff is to pull that one into my for-next branch
and build all defconfigs and all{yes,no,mod}config.

	Arnd
