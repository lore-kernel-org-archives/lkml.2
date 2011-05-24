Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1EXPB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:01:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1EXPB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:01:28 -0400
Message-ID: <4DDBC846.8050402@suse.cz>
Date: Tue, 24 May 2011 17:01:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Hiromu Yakura <hiromu1996@gmail.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
References: <1306167401.18840.8.camel@hiromu-MacBook>	 <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>	 <1306242400.7501.10.camel@hiromu-MacBook>  <4DDBB150.2090602@suse.cz> <1306247192.7501.25.camel@hiromu-MacBook>
In-Reply-To: <1306247192.7501.25.camel@hiromu-MacBook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.5.2011 16:26, Hiromu Yakura wrote:
> Hello,
>
> On Fri, May 24, 2011 at 22:23, Michal Marek<mmarek@suse.cz>  wrote:
>> Arnaud's point is that your patch should not be necessary at all,
>> because kconfig already checks the return value of the fopen() call in
>> conf_write() and prints the above message if it fails. So do you have a
>> testcase where make<...>config without your patch returns without
>> error, but the configuration is not written?
> Sorry for misunderstanding.
> Indeed, make *config which use 'conf' (e.g. oldconfig, defconfig...)
> raise error.
> And only xconfig and gconfig don't write the configuration without
> error.

I see, qconf lacks a check for the return value of conf_write() in 
ConfigMainWindow::closeEvent(), gconf does check the return value, but 
only displays it in the bottom box of the main window instead of a 
message box. Neither of them return failure in the error case. These 
bugs should be indeed fixed. But I don't like the directory permission 
check, it only handles one case, but does not handle permission on the 
.config file itself with KCONFIG_OVERWRITECONFIG=1, ENOSPC and so on.

Michal
