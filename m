Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428Ab1CYKpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:45:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37188 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934195Ab1CYKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=ZPqifG89LPz9CrDGm+s4TORN97uYJbPVl0Ube3NrFCt4TnDusMfnCYaj0dQcZu5ocC
         /aPjQBoZKQbqnj2vaUgv7uQ9SvYKr/+CeXzolNAVtyyF6mCMFcTjyRGU7yCtWAaC/yJ6
         oioPfJ9mnOhXbO9+PzFIuxFDR4CiMpncc+fkM=
Message-ID: <4D8C7253.3040204@suse.cz>
Date: Fri, 25 Mar 2011 11:45:39 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Should .dtr_rts do tty_port_tty_get?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm playing with a serial device and got a nice oops. Maybe after some
weird stty's, I don't know. But it dies in uart_dtr_rts:
        .loc 1 1535 0
        movq    (%rbx), %r13    # port_1(D)->tty, D.26746
...
        .loc 1 1494 0
        testb   $2, 224(%r13)   #, D.26746_10->flags
                    ^^^^^^^^^
                      HERE

Because r13 (port->tty) is NULL. So the question is about the principle.
Should it call tty_port_tty_get or is it a bug in the TTY layer and
uart_dtr_rts should not be called with port->tty == NULL?

I'll attach a patch which does the former as a reply to this message.

BTW only serial_core needs tty in dtr_rts.

thanks,
-- 
js
suse labs
