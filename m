Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0IUS5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:57:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35831 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0IUS5H (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Sep 2010 14:57:07 -0400
Date: Tue, 21 Sep 2010 14:55:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
Message-ID: <20100921185513.GA22929@dumpdata.com>
References: <cover.1284733808.git.jbaron@redhat.com>
 <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
 <20100921182945.GA22088@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921182945.GA22088@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +early_initcall(init_jump_label);
> 
> Is there any danger of not patching the instructions with NOPs before
> early_initcall is called? I guess for your uses (tracing) there won't.
> And even if there are not patched it will just call the function.

Ah, nevermind - if you don't patch the addresses which are in
_jump_label section, the untouched code will just do far jump (jmpq)
to right after the macro, which is ok.
