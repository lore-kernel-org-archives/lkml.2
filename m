Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab1GKRwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:52:14 -0400
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:49057 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1GKRwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:52:05 -0400
Message-ID: <4E1B3816.2030606@genband.com>
Date: Mon, 11 Jul 2011 11:51:18 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: loody <miloody@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: how to find a task through name faster?
References: <CANudz+sqkachOT7r9=-rc98nCEO_QOCx7KiBi5=NWaj5exmEPA@mail.gmail.com> <CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>
In-Reply-To: <CANudz+vxY_0NY2veJ9Wvr08x_z3e20m=g7ZL4bZDi=-vaOF7dQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Jul 2011 17:51:19.0048 (UTC) FILETIME=[23675880:01CC3FF3]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18254.000
X-TM-AS-Result: No--13.135400-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 10:52 AM, loody wrote:
> hi all:
> I found a way to find a task I need by name, test,  as below:
> for_each_process(task) {
>      if(strcmp(task->comm, "test")
>          printk(“%s[%d]\n”, task->comm, task->pid);
> }
>
> But it is time-consuming to do so if I periodically want to know
> whether "test" exist or not.
> is there better way to do so?

The names of tasks isn't indexed in any way so the above is about as 
good as it gets if that's all the information you have.

One common way around that is to store the PID in a file somewhere at 
startup.  Then you can look in the file and see if that PID is present 
and check "task->comm" to make sure it's what you expect.  This saves 
having to search through all tasks.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
