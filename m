Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2DUMl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:41:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54934 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab2DUMlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:41:02 -0400
Date: Sat, 21 Apr 2012 13:40:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: akpm@linux-foundation.org, mturquette@linaro.org, sshtylyov@mvista.com,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        jgarzik@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/13] clk: CLK_PREPARE must depend on HAVE_CLK
Message-ID: <20120421124043.GG24211@n2100.arm.linux.org.uk>
References: <cover.1335008617.git.viresh.kumar@st.com> <ffaffaeeb39c5b7741ee8e616682d51d213fa512.1335008617.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffaffaeeb39c5b7741ee8e616682d51d213fa512.1335008617.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 05:17:30PM +0530, Viresh Kumar wrote:
> CLK_PREPARE must have dependency on HAVE_CLK. Add it.

No - its possible to have HAVE_CLK_PREPARE selected independently of
HAVE_CLK.  Why do we want to end up having to add conditionals all
over the place for 'select HAVE_CLK_PREPARE' ?

The only time HAVE_CLK_PREPARE gets used is in a header file, where you're
already making it conditional on HAVE_CLK.  Nothing else should know about
HAVE_CLK_PREPARE.
