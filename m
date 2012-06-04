Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729Ab2FDPAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:00:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab2FDPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:00:00 -0400
Message-ID: <4FCCCD5D.6010005@zytor.com>
Date: Mon, 04 Jun 2012 07:59:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Witold Baryluk <baryluk@smp.if.uj.edu.pl>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: WARNING: arch/x86/built-in.o: Section mismatch in reference from
 the variable test_nmi_ipi_callback_na to function .ini.text:test_nmi_ipi_callback
References: <20120602161502.GW16584@smp.if.uj.edu.pl> <20120604143643.GJ32472@redhat.com>
In-Reply-To: <20120604143643.GJ32472@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 07:36 AM, Don Zickus wrote:
> 
> Basically the test registers two nmi_handlers, run some tests, and
> then unregisters them.  Those handlers are what the compiler seems to be
> complaining about.  I do not know what magic to pass the compiler to let
> it know that both of the handlers will be unregistered before the init
> section is destroyed.
> 
> Perhaps I should tag those callbacks with __ref? I am not sure the right
> thing to do here.
> 

Using __ref is the right thing, although __ref is hard to use right...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

