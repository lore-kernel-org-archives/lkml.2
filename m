Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab2A2Dgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 22:36:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48012 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2A2Dgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 22:36:36 -0500
Message-ID: <4F24BEB5.5070402@gmail.com>
Date: Sun, 29 Jan 2012 11:36:21 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Bryan Jacobs <its@easytoremember.us>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/[pid]/mem write implications
References: <20120128203250.090abec6@easytoremember.us>
In-Reply-To: <20120128203250.090abec6@easytoremember.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2012 09:32 AM, Bryan Jacobs wrote:
> Dear LKML,
>
> I have a few questions on the recent change to allow writing
> to /proc/[pid]/mem. If I understand correctly, the recent
> privilege-escalation vulnerability was fundamentally caused by
> incorrectly verifying that the memory being written to by a process was
> its own. The goal was to only allow processes to write to their own
> memory space - this was deemed harmless.


Well, the more fundamental vulnerability is the check was done in 
write(2) instead of open(2), which leaves a window for exploits.

>
> But I think that allowing arbitrary processes to write to **their own**
> memory via a file descriptor might in itself be problematic. Please,
> help me understand how this is safe.

You will have a sysctl to control if it is writable.

Thanks.
