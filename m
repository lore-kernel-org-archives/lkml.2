Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0FIJrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:47:25 -0400
Received: from www.tglx.de ([62.245.132.106]:45323 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab0FIJrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:47:24 -0400
Date: Wed, 9 Jun 2010 11:46:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Mickler <florian@mickler.org>
cc: pm list <linux-pm@lists.linux-foundation.org>, james.bottomley@suse.de,
       markgross@thegnar.org, mgross@linux.intel.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pm_qos: make update_request callable from interrupt
 context
In-Reply-To: <1276074915-26879-2-git-send-email-florian@mickler.org>
Message-ID: <alpine.LFD.2.00.1006091146010.2933@localhost.localdomain>
References: <1276074915-26879-1-git-send-email-florian@mickler.org> <1276074915-26879-2-git-send-email-florian@mickler.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, florian@mickler.org wrote:

> The pm_qos framework has to guarantee atomic notifications so that
> drivers can request and release constraints at all times while no races
> occur.
> 
> In order to avoid implementing a secondary notification chain in which
> listeners might sleep, we demand that every listener implements it's
> notification so that it can run in interrupt context. The listener is in
> a better position to know if races are harmful or not.

That breaks existing notifiers.

Thanks,

	tglx
