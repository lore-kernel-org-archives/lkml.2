Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1EINuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:50:11 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:62586 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1EINuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:50:09 -0400
Message-ID: <3A9C5CD56396439DBF825BB4E5779DB9@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Andrew Morton \(commit_signer:1/4=25%\)" <akpm@linux-foundation.org>,
        "Randy Dunlap \(commit_signer:1/4=25%\)" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com><1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com><034A6447E0D54737B5CEE009A4D20B37@subhasishg> <20110509144610.6b4f7090@lxorguk.ukuu.org.uk>
In-Reply-To: <20110509144610.6b4f7090@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Date: Mon, 9 May 2011 19:20:17 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I then modified this function to as follows and the error is not observed
>> anymore.
>
> That looks like you are somehow calling uart_carrier_raised somewhere
> with interrupts disabled ?
>
I am not calling this function in my driver atall, this is getting called by 
tty_port.c

int tty_port_block_til_ready(struct tty_port *port,
                                struct tty_struct *tty, struct file *filp)
{
 /* Probe the carrier. For devices with no carrier detect this
                   will always return true */
                cd = tty_port_carrier_raised(port);
                if (!(port->flags & ASYNC_CLOSING) &&
                                (do_clocal || cd))
                        break;
                if (signal_pending(current)) {
                        retval = -ERESTARTSYS;
                        break;
                }

 

