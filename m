Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1C1KFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:05:41 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:63989 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1C1KFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:05:40 -0400
X-AuditID: 83cfa826-b7c19ae000000a2e-ff-4d905d72ea52
From: <Lukasz.Rymanowski@tieto.com>
To: <tglx@linutronix.de>, <par-gunnar.p.hjalmdahl@stericsson.com>
CC: <gregkh@suse.de>, <devel@driverdev.osuosl.org>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <pavan_savoy@sify.com>, <vitalywool@gmail.com>,
        <alan@lxorguk.ukuu.org.uk>, <arnd@arndb.de>, <marcel@holtmann.org>,
        <linus.walleij@stericsson.com>, <pghatwork@gmail.com>,
        <lee.jones@linaro.org>, <mathieu.poirier@linaro.org>
Date: Mon, 28 Mar 2011 13:05:35 +0300
Subject: RE: [PATCH v2 1/2] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH v2 1/2] staging: Add ST-Ericsson CG2900 driver
Thread-Index: AcvtKH2OE49clRIQSaC16kTmNUwA/QABAygw
Message-ID: <7D7F2FD3846CF6429ACEBDFB5A2DD86F07E35E5F89@EXMB01.eu.tieto.com>
References: <1301302950-10628-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <alpine.LFD.2.00.1103281110210.31464@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103281110210.31464@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/**
>> + * cts_interrupt() - Called to handle CTS interrupt.
>> + * @irq:	Interrupt that occurred.
>> + * @dev_id:	Device ID where interrupt occurred.
>> + *
>> + * The cts_interrupt() function is called if interrupt on CTS occurred.
>> + * It disables the interrupt and starts a new work thread to handle
>> + * the interrupt.
>> + */
>> +static irqreturn_t cts_interrupt(int irq, void *dev_id) {
>> +	struct uart_info *uart_info = dev_get_drvdata(dev_id); #ifdef 
>> +CONFIG_PM
>> +	disable_irq_wake(irq);
>> +#endif
>> +	disable_irq_nosync(irq);
>> +
>> +	/* Create work and leave IRQ context. */
>> +	(void)create_work_item(uart_info, handle_cts_irq);
>> +
>> +	return IRQ_HANDLED;
>> +}

>Have you thought about using a threaded interrupt handler? That would make all this work cruft go away.

Good point.
To be honest we did think about it but in the time we where we were busy with other issues.
Anyway, shall we resend patches now or we can push patch for it once driver gets in the tree ?

/Lukasz

>Thanks,

>	tglx
