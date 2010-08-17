Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0HQRPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:15:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43793 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0HQRPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:15:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6077"; a="51320723"
Message-ID: <4C6AC393.8000109@codeaurora.org>
Date: Tue, 17 Aug 2010 13:14:59 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <20100813024912.GA2661@core.coreip.homeip.net> <4C65BF99.9030601@codeaurora.org> <201008131754.49488.dmitry.torokhov@gmail.com>
In-Reply-To: <201008131754.49488.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2010 8:54 PM, Dmitry Torokhov wrote:
> Also it is not a simple coincidence that to enable device you send 0xf4
> to it (which is PSMOUSE_CMD_ENABLE - standard PS/2 command). This tends
> to suggest that interface is not actually hidden and that the device
> (touchpad) could be replaced with other kinds of devices.
>
> Anyway, please try the driver (you  may need to hardcode the IRQ trigger
> type for now) and see if psmouse is able to talk to the touchpad. If it
> is then serio is the proper solution.

Dmitri,
I fixed one line in the wpce775x_serio driver which looked like a typo - 
hope I got that right:

	for (i = 0; i < count; i++)
-		serio_interrupt(ps2if->serio, ps2if->data_in[1], 0);
+		serio_interrupt(ps2if->serio, ps2if->data_in[i], 0);
	}

I tried running with psmouse but it didn't work. The touchpad was never 
detected as a synaptics touchpad. I looked at the dataflow from the 
device and it wasn't responding to the commands that synaptics_detect() 
was sending it. It eventually showed up as an unknown logitech mouse. I 
can see data being passed through the serio driver but the logitech 
driver can't process it.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
