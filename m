Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1IFVId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:08:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61044 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1IFVI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:08:26 -0400
Message-ID: <4E668BBF.4020600@gmail.com>
Date: Tue, 06 Sep 2011 23:08:15 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] at91: add code to initialize and manage the
 ISI_MCK for Atmel ISI driver.
References: <1315288601-22384-1-git-send-email-josh.wu@atmel.com>	<Pine.LNX.4.64.1109060803590.14818@axis700.grange> <20110906200512.GA15083@game.jcrosoft.org>
In-Reply-To: <20110906200512.GA15083@game.jcrosoft.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 10:05 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> I'm not entirely sure on this one, but as we had a similar situation with
>> clocks, we decided to extablish the clock hierarchy in the board code, and
>> only deal with the actual device clocks in the driver itself. I.e., we
>> moved all clk_set_parent() and setting up the parent clock into the board.
>> And I do think, this makes more sense, than doing this in the driver, not
>> all users of this driver will need to manage the parent clock, right?
>
> I don't like to manage the clock in the board except if it's manadatory otherwise
> we manage this at soc level
> 
> the driver does not have to manage the clock hierachy or detail implementation
> but manage the clock enable/disable and speed depending on it's need

We had a similar problem in the past and we ended up having the boot loader
setting up the parent clock for the device clock. The driver only controls clock
gating and sets its clock frequency based on an internal IP version information,
derived from the SoC revision.

AFAIK there is also a generic API at the runtime PM core so the driver can
register the clock(s) with it and only use pm_runtime_clk_* calls afterwards.

--
Regards,
Sylwester
