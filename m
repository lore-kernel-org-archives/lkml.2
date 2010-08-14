Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab0HNWKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 18:10:37 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:34692 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755953Ab0HNWKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 18:10:36 -0400
Message-ID: <4C671455.4040908@example.com>
Date: Sun, 15 Aug 2010 00:10:29 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <20100814210044.GA29375@merkur.ravnborg.org>
In-Reply-To: <20100814210044.GA29375@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 1465921680817549721
X-Ovh-Remote: 83.24.79.106 (dmx106.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.08.2010 23:00, Sam Ravnborg wrote:
> On Sat, Aug 14, 2010 at 10:53:17PM +0200, Piotr Hosowicz wrote:
>> Hello,
>>
>> I build new kernels when they become available. Now I have a problem.
>> After I install new kernel I have to run NVidia setup script. Starting
>> from git15 it fails, see attached file. The error line is here:
>>
>>     /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c: At top level:
>>     /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: error:
>> unknown field ‘ioctl’ specified in initializer
>>     /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: warning:
>> initialization from incompatible pointer type
>
> The likely culprint is:
> b19dd42faf413b4705d4adb38521e82d73fa4249
> (bkl: Remove locked .ioctl file operation)
>
> This commit finally killed ioctl from file_operations, as part of the
> bkl removal project.

Yes, this was it. I made git pull and git revert and now I am up and 
kicking. But how will I manage with it not by git but by kernel org 
provioded files? And even if I used git all the time will I have to 
revert it each time and what's the worse I will become more and more out 
of sync because people will write their code as if I did not revert.

Thanks for your help. Regards,

Piotr Hosowicz

-- 
- Jaka jest największa anomalia fizjologiczno-polityczna?
- Członek wysunięty z ramienia na czoło.
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.35-20100814-2310+
