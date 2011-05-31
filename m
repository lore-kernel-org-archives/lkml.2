Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1EaRyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:54:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab1EaRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:54:07 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=MXrvIagEJvMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=H8pkIGVybOjKD7cp2BsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: tracepoint of net_dev_xmit sees freed skb and
 causes panic
From: Steven Rostedt <rostedt@goodmis.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, mingo@elte.hu,
        fweisbec@gmail.com, mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kaneshige.kenji@jp.fujitsu.com
In-Reply-To: <20110531161115.GA3267@hmsreliant.think-freely.org>
References: <4DE49D52.709@jp.fujitsu.com>
	 <1306854791.11899.30.camel@gandalf.stny.rr.com>
	 <20110531161115.GA3267@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 May 2011 12:21:30 -0400
Message-ID: <1306858890.11899.32.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 12:11 -0400, Neil Horman wrote:
>  			skb_dst_drop(nskb);
> > >  
> > > +		skb_len = nskb->len;
> > >  		rc = ops->ndo_start_xmit(nskb, dev);
> > > -		trace_net_dev_xmit(nskb, rc);
> > > +		trace_net_dev_xmit(nskb, rc, dev, skb_len);
> > 
> > What if you just put the tracepoint before the call to
> > ops->ndo_start_xmit?
> > 
> Then you won't know the return code of ndo_start_xmit, which this tracepoint
> records.

Doh! Yeah, I see that now ;)

-- Steve


