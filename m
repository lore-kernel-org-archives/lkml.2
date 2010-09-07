Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0IGW0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:26:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47670 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0IGW0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lL2ipXVIX9TpZ8j9wVXuvTU2NEkPtxRIjYn5mVO99W5pKr+yG2pJ28TCRVPwRu8Wxx
         0txlH80IWQXsPUUFBJnz50VoWnOjdqtzMmEEDJaofxIHEtatEP6ZJQciVji+3G++G7vi
         gsIWxQdGOCL4NCH3+2U7TiZO7XUfROWyBZJtM=
MIME-Version: 1.0
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F23479F74@SC1EXMB-MBCL.global.atheros.com>
References: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
	<8b251244717765e795b92a1f7335f8af98e5706f.1283872748.git.andy.shevchenko@gmail.com>
	<35B17FE5076C7040809188FBE7913F983F23479F74@SC1EXMB-MBCL.global.atheros.com>
Date: Wed, 8 Sep 2010 01:26:05 +0300
Message-ID: <AANLkTi=ppiChKzzeBqOhjPQHavoS6RCQWNS377hqtji6@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: ath6kl: use native methods from kernel library
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vipin Mehta <Vipin.Mehta@atheros.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 12:18 AM, Vipin Mehta <Vipin.Mehta@atheros.com> wrote:
> Andy,
>   Thanks for the patch. Although the driver supports Linux but it has been architected to support other OSes if desired. The code is, therefore, organized into generic and OS specific components with the latter part of the code captured into the os/linux directory. As such, the patch will be more useful if we can move out the inclusion of linux specific header files <linux/kernel.h> and <linux/ctype.h> into a header file in os/linux/include directory. You can refer to os/linux/include/osapi_linux.h for example. A macro could be defined which would use linux specific APIs for Linux and keep the original definitions for any other OS.

The file ar3kpsparser.h, which is directly included by patched one,
contains few includes like <linux/XXX.h>. Due to this I consider this
part of code as OS-dependent. That's why I decide to put necessary
headers inside c-file.
Thus I think patch could be applied w/o modifications. However, If you
want to do me some odd stuff (at least until I have not got the clear
explanation), I could provide you 3 patches: clean up file under
os/linux, remove unused macros, and fix in ar3kpsparser in way when
necessary os-dependent headers will be located at some common header.


-- 
With Best Regards,
Andy Shevchenko
