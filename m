Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab1HWESO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 00:18:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44260 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1HWESG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 00:18:06 -0400
Message-ID: <4E5329E8.7060608@gmail.com>
Date: Mon, 22 Aug 2011 21:17:44 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: module param for CPU_NOTIFIER_ERROR_INJECT
References: <4E5153D8.7010607@gmail.com> <CAC5umyh3S0Xrc0OOXk7TzsQqF0t1ostKtR_5hqFwN_EkcgwuxA@mail.gmail.com> <CAKFRV=PSQT7Wt01gxirnkJEJv2GvQ7ELkd8QvxhT6BjXnBgQsw@mail.gmail.com>
In-Reply-To: <CAKFRV=PSQT7Wt01gxirnkJEJv2GvQ7ELkd8QvxhT6BjXnBgQsw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 09:41 AM, Justin Mattock wrote:
> Cool.. I will retry on this and let you know.
>
> On Aug 22, 2011 5:48 AM, "Akinobu Mita" <akinobu.mita@gmail.com
> <mailto:akinobu.mita@gmail.com>> wrote:
>  > 2011/8/22 Justin P. Mattock <justinmattock@gmail.com
> <mailto:justinmattock@gmail.com>>:
>  >
>  >> example 2
>  >> # modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
>  >> # echo 1 > /sys/devices/system/cpu/cpu1/online
>  >> bash: echo: write error: No such file or directory
>  >>
>  >> is not working for me, or atleast is not showing me any info that it is
>  >> working.
>  >
>  > I suspect that cpu-notifier-error-inject module is already loaded and
>  > the module parameter is just ignored when you run above commands.
>  >
>  > Please retry it after rmmod or change that parameter through
>  > /sys/module/cpu-error-inject/parameters/cpu_up_prepare_error.
>

cool, Thanks for the help.. not sure if this is correct, but I had to 
shutdown one of the cores, then execute the cammand to get any response..:

echo 0 > /sys/devices/system/cpu/cpu1/online
modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
echo 1 > /sys/devices/system/cpu/cpu1/online

[ 4205.955592] Injecting error (-2) at cpu notifier
[ 4205.955601] _cpu_up: attempt to bring up CPU 1 failed

so it is working!

Justin P. Mattock
