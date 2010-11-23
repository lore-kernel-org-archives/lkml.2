Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0KWOuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:50:01 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51300 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0KWOuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:50:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=aQzk1o5I37SxbQyQd5iP52jOdU3aH0YJGNcjop/DH/qartdn0XgjKkutdV6mfQ9AY8
         DP9UwcW1E8co4XoQeH3Pj/ETjIpVNwCI99WsZNw1w/AMPMwQQO6WTvs6A8BlUF+NLQeF
         sKxl144SbwDv7TAEoekvNUn/6OlMsimwMwISo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 23 Nov 2010 15:49:57 +0100
Message-ID: <AANLkTin6ZJr3vXw=HVeA65aq39qxtnJGGXW2nwfp_PwS@mail.gmail.com>
Subject: Re: linux-next: boot failure in sep driver
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, mark.a.allyn@intel.com,
        jayant.mangalampalli@intel.com
Cc: sfr@canb.auug.org.au, Greg KH <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just fall into the same pitfall... While digging into this driver, I
saw a typo in:

[ drivers/staging/sep/Kconfig ]

config DX_SEP
        tristate "Discretix SEP driver"
        depends on PCI
        default y
        help
          Discretix SEP driver; used for the security processor subsystem
          on bard the Intel Mobile Internet Device.

          The driver's name is sep_driver.

          If unsure, select N.
- EOF -

Shouldn't this be "...used for the security processor subsystem...
"...*shipped with Intel Mobile Internet Devices.*" ?
I can only imagine that the original author(s) wanted to figure out it
is an onboard-solution.


Kind Regards,
- Sedat -

P.S.: Note to myself: Add the folowing snippet to:

[ debian/config/config ]
...
##
## file: drivers/staging/sep/Kconfig
##
# CONFIG_DX_SEP is not set
...
