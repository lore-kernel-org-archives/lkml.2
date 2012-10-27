Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2J0GzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 02:55:04 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:61426 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2J0GzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 02:55:02 -0400
Message-ID: <508B8536.1080303@synopsys.com>
Date: Sat, 27 Oct 2012 12:24:46 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <alan@linux.intel.com>,
        <arc-linux-dev@synopsys.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] serial/arc-uart: Add new driver
References: <1351252996-28484-1-git-send-email-vgupta@synopsys.com> <1351252996-28484-2-git-send-email-vgupta@synopsys.com> <20121026121032.GD26342@arwen.pp.htv.fi>
In-Reply-To: <20121026121032.GD26342@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012 05:40 PM, Felipe Balbi wrote:
> On Fri, Oct 26, 2012 at 05:33:16PM +0530, Vineet.Gupta1@synopsys.com wrote:
>> +/*
>> + * Release the memory region(s) being used by 'port'.
>> + */
>> +static void arc_serial_release_port(struct uart_port *port)
>> +{
>> +}
>> +
>> +/*
>> + * Request the memory region(s) being used by 'port'.
>> + */
>> +static int arc_serial_request_port(struct uart_port *port)
>> +{
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Verify the new serial_struct (for TIOCSSERIAL).
>> + */
>> +static int
>> +arc_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
>> +{
>> +	return 0;
>> +}
> why all these empty functions with wrong comments above them ??

Actually serial_core.c invokes the reqest/release callbacks w/o
verifying for a NULL pointer check. Thus they need to be in there even
if empty. I've removed the offending comments though !

-Vineet
