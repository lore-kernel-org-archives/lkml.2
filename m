Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0IFLcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:32:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab0IFLci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:32:38 -0400
Message-ID: <4C84D154.7070303@suse.cz>
Date: Mon, 06 Sep 2010 13:32:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xconfig: Change the titlebar if using Qt3
References: <1283355997-6900-1-git-send-email-mmarek@suse.cz> <201009021852.40023.alexander.stein@informatik.tu-chemnitz.de>
In-Reply-To: <201009021852.40023.alexander.stein@informatik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.9.2010 18:52, Alexander Stein wrote:
> Hello Marek,
> 
> On Wednesday 01 September 2010 17:46:37 Michal Marek wrote:
>> Qt4 is now used by default and will get more testing. In case someone
>> still uses Qt3 and reports a bug, make it easy to recognize that this is
>> Qt3.
>>
>> Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> ---
>>  scripts/kconfig/qconf.cc |   10 ++++++++--
>>  1 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
>> index 88d3874..a04e451 100644
>> --- a/scripts/kconfig/qconf.cc
>> +++ b/scripts/kconfig/qconf.cc
>> @@ -1274,8 +1274,14 @@ ConfigMainWindow::ConfigMainWindow(void)
>>  	char title[256];
>>
>>  	QDesktopWidget *d = configApp->desktop();
>> -	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration"),
>> -		getenv("KERNELVERSION"));
>> +	snprintf(title, sizeof(title), _("Linux Kernel v%s Configuration%s"),
>> +		getenv("KERNELVERSION"),
>> +#if QT_VERSION < 0x040000
>> +		" (Qt3)"
>> +#else
>> +		""
>> +#endif
>> +		);
>>  	setCaption(title);
>>
>>  	width = configSettings->readNumEntry("/window width", d->width() - 64);
> 
> Looks fine to me.

OK, I committed it with "Acked-by: <you>"

thanks,
Michal
