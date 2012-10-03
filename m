Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2JCHKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:10:51 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:64650 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2JCHKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:10:49 -0400
Message-ID: <506BE4EB.4010904@synopsys.com>
Date: Wed, 3 Oct 2012 12:40:35 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] serial/arc-uart: Add new driver
References: <1349154216-7906-1-git-send-email-vgupta@synopsys.com> <20121002124707.32b70292@bob.linux.org.uk>
In-Reply-To: <20121002124707.32b70292@bob.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2012 05:17 PM, Alan Cox wrote:
>> +/* Is this for UART emulation on ARC Instruction Set Simulator (ISS)
>> */ +int __attribute__((weak)) running_on_iss;
> Why not pass a quirks field in your platform data instead - much
> cleaner than a global.

I'd thought about it too. However the platform data is retrieved in
arc_uart_init_one() while it's usage in arc_serial_set_termios() will be
in a different call chain, meaning this info will have to be anyways
saved in "some" data structure - probably within struct arc_uart_port -
and that too per port - which is not clean either. However if you
strongly feel that the global is a must go - I can rework it that way.

thx,
-Vineet

