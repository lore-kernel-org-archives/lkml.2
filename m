Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab1CCNzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:55:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab1CCNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:55:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peppe CAVALLARO <peppe.cavallaro@st.com>
Subject: Re: [PATCH (sh-2.6) 1/4] clksource: Generic timer infrastructure
Date: Thu, 3 Mar 2011 14:55:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Stuart MENEFY <stuart.menefy@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
References: <1298369864-24429-1-git-send-email-peppe.cavallaro@st.com> <201103030945.07486.arnd@arndb.de> <4D6F6C96.1010303@st.com>
In-Reply-To: <4D6F6C96.1010303@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031455.25089.arnd@arndb.de>
X-Provags-ID: V02:K0:zC+QW3tUu2sHiO/DE3RDj0UF+3H2XZDJnrrYLNE27gL
 Xdkj3FH4Sgavx9e8GKhLxBhrCUDT2cFKB9wGl0N3NGw5QMc+vn
 pGLLioE3Tmo7ZXjE+aBgnwbrpJ9iwL7yrFFopi5tbg8WeqNUFd
 7RzSXNeKPxRqWiRG7ShmxW9C488PKIpc7hz9FHo158+81YlPms
 cYi6HV7Kt5hVMBLwex9Dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 March 2011, Peppe CAVALLARO wrote:
> This logic is already in the driver, indeed.
> What I've seen on our embedded systems is that the
> cost of RX interrupts is very hight and NAPI partially helps.
> Typically, in an IP-STB, I receive a burst of UDP pkt
> and this  means that many interrupts occur (~99% of CPU
> usage on slow platforms).
> With the ext timer I was able to reduce the CPU usage in
> these kind of scenarios to ~50%.

I don't understand. Shouldn't the interrupts be stopped as long
as the system is busy? This sounds like a bug in your NAPI
handling, or maybe you just need to use a lower NAPI_WEIGHT
so you stay in polling mode longer.

	Arnd
