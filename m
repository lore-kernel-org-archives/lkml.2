Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0DSVJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:09:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38361 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0DSVJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:09:11 -0400
Message-ID: <4BCCC4E1.8040109@zytor.com>
Date: Mon, 19 Apr 2010 14:02:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE
 is undefined
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com>	 <1270497725.1477.488.camel@groeck-laptop>  <4BBA473D.9040004@zytor.com>	 <1270501481.1477.521.camel@groeck-laptop>  <4BBA51F3.7070808@zytor.com> <1270505579.1477.584.camel@groeck-laptop>
In-Reply-To: <1270505579.1477.584.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

I wanted to check where we are at... at the very least we should drop
messages issued before initialization when isVGA != 1.

Since serial ports require initialization, I really don't want to send
messages to the serial port before the port has been initialized, but
obviously it would be good to initialize earlyprintk as early as at all
possible.

	-hpa

