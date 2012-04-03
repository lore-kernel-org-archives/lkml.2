Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2DCJxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:53:21 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45046 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2DCJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:53:19 -0400
Date: Tue, 3 Apr 2012 10:55:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Shankarmurthy, Akshay" <akshay.s@ti.com>
Cc: <linux-serial@vger.kernel.org>, <alan@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <paul.gortmaker@windriver.com>,
        <jamie@jamieiles.com>, <swarren@nvidia.com>, <dianders@chromium.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Chaithrika U S <chaithrika@ti.com>
Subject: Re: [PATCH] serial: 8250: Add cpufreq support
Message-ID: <20120403105530.7fa3bce7@pyramind.ukuu.org.uk>
In-Reply-To: <1333433022-5455-1-git-send-email-akshay.s@ti.com>
References: <1333433022-5455-1-git-send-email-akshay.s@ti.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch was submitted 2 years ago but didn't make it to the mainline. Now i am reposting it.

Can you fix it instead of just reposting it ?


> +#ifdef CONFIG_CPU_FREQ
> +static int serial8250_cpufreq_transition(struct notifier_block *nb,
> +					     unsigned long val, void *data)
> +{
> +	struct uart_8250_port *p;
> +	struct uart_port *uport;

What is your locking model ?


> +static inline void serial8250_cpufreq_deregister(struct uart_8250_port *p)

unregister

> +		ret = serial8250_cpufreq_register(uart);
> +		if (ret < 0)
> +			printk(KERN_ERR "Failed to add cpufreq notifier\n");

Why do this for devices that don't care.

Alan
