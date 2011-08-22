Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1HVFGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 01:06:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34573 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1HVFGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 01:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C2CD7600DD@HKMAIL01.nvidia.com>
References: <1311834636-15940-1-git-send-email-wni@nvidia.com>
	<20110821230511.GA4607@sortiz-mobl>
	<6B4D417B830BC44B8026029FD256F7F1C2CD7600DD@HKMAIL01.nvidia.com>
Date: Mon, 22 Aug 2011 13:06:02 +0800
Message-ID: <CAN1soZzkmP=ckzAOJv59YfYtFU63nC9j-Oa+cM5z674yf0Mihw@mail.gmail.com>
Subject: Re: [PATCH] mfd: tps6586x: add api to power off tps6586x
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Wei Ni <wni@nvidia.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "mike@compulab.co.il" <mike@compulab.co.il>,
        Nitin Kumbhar <nkumbhar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 11:47 AM, Wei Ni <wni@nvidia.com> wrote:
> Hi, Samuel
> Thanks for your comments.
> Please check the following lines with [Wei Ni]
>
> Thanks
> Wei.
>
>
>>-----Original Message-----
>>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>>Sent: Monday, August 22, 2011 7:05 AM
>>To: Wei Ni
>>Cc: mike@compulab.co.il; gking@nvidia.com; Nitin Kumbhar; linux-kernel@vger.kernel.org
>>Subject: Re: [PATCH] mfd: tps6586x: add api to power off tps6586x
>>
>>Hi Wei,
>>
>>On Thu, Jul 28, 2011 at 02:30:36PM +0800, wni@nvidia.com wrote:
>>> +static struct i2c_client *tps6586x_i2c_client;
>>That's not vey nice. By doing so, you're preventing anyone to have more than
>>one of those chips in their boards.
> [Wei Ni] oh yes, I didn’t consider this issue. We use i2c_register_board_info()
> to register the tps6586x in the board file, but it didn't return the handle.
> Do you have any ideas?
>>
>>

Since there's no parameter in pm_power_off(), invoking power off
function is a known issue
for i2c devices. And we can't get i2c client in board file.

Maybe we can add a LDO mapping in regulator driver. Since power-off
function is always
customized in board file. We can disable this regulator while
power_off() is called. So even
multiple PMICs is installed in one system, we only handle the real one
to shutdown the
whole system.

Samuel & Mark,
Do you think that it's worth to do?

Thanks
Haojian
