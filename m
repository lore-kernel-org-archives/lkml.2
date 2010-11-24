Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0KXPPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:15:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0KXPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:15:07 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=UaNWXry1k3EA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yin8vVtzoePS9lAww6EA:9 a=OkYWv2rrc9cP4GBr8TD7_GmLzLgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20101124145401.GA2815@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <1290586809.2072.424.camel@laptop>  <20101124145401.GA2815@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Nov 2010 10:15:02 -0500
Message-ID: <1290611702.30543.488.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 09:54 -0500, Jason Baron wrote:
> On Wed, Nov 24, 2010 at 09:20:09AM +0100, Peter Zijlstra wrote:
> > On Tue, 2010-11-23 at 16:27 -0500, Jason Baron wrote:
> > >         struct hlist_head modules;
> > >         unsigned long key;
> > > +       u32 nr_entries : 31,
> > > +              enabled :  1;
> > >  }; 
> > 
> > I still don't see why you do this, why not simply mandate that the key
> > is of type atomic_t* and use *key as enabled state?
> > 
> 
> Because I want to use *key as a pointer directly to 'struct jump_label_entry'.
> In this way jump_label_enable(), jump_label_disable(), become O(1) operations.
> That way we don't need any hashing.

I'm curious, how are you going to get the keys to point to the jump
label structures?

-- Steve


