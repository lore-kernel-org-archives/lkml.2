Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab0FRNwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:52:49 -0400
Received: from relay.atmel.no ([80.232.32.139]:62186 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab0FRNws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:52:48 -0400
Date: Fri, 18 Jun 2010 15:52:34 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "'Shiraz HASHIM'" <shiraz.hashim@st.com>,
       Armando VISCONTI <armando.visconti@st.com>
Subject: Re: Query dw_dmac driver: All descriptors done, but channel not
 idle!
Message-ID: <20100618155234.1fc40ce7@hskinnemoen-d830>
In-Reply-To: <4C1B75B7.1080104@st.com>
References: <4C1B75B7.1080104@st.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh KUMAR <viresh.kumar@st.com> wrote:
> Can somebody please confirm, if it a known issue or not? Or if there
> are some solutions for this problem.

I'm not aware of any such issue. The code was added as a purely
defensive thing; when writing it, I just thought about what might
happen if we go through all our descriptors without finding the current
one, and added some code to report the issue and try to recover.

I suppose it might be caused by some issue with the peripheral itself,
but I think it's more likely to be caused by some race condition in the
driver, i.e. something goes wrong when inserting or removing
descriptors in the chain.

What might be very good to know at this point is the value of
the llp variable, and perhaps also the value of the CH_EN register to
see if the channel is idle or not.

Haavard
