Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2BBWxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:53:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab2BBWxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:53:12 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=YiKPRh2-Ynl6pai5ZOIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328223190.5882.128.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 02 Feb 2012 17:53:10 -0500
In-Reply-To: <4F2B090F.5020609@zytor.com>
References: <20120128160925.275163704@goodmis.org>
	  <20120130144857.GA22013@elte.hu>
	  <1327936060.22710.165.camel@gandalf.stny.rr.com>
	  <20120131194813.GA12074@elte.hu>
	  <1328072925.5882.57.camel@gandalf.stny.rr.com>
	  <20120201080539.GA11770@elte.hu>
	  <1328109697.5882.65.camel@gandalf.stny.rr.com>
	  <20120202135154.GA10315@elte.hu> <4F2A9960.2090500@zytor.com>
	  <1328193068.5882.95.camel@gandalf.stny.rr.com>
	 <1328220280.5882.122.camel@gandalf.stny.rr.com>
	 <4F2B090F.5020609@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 14:07 -0800, H. Peter Anvin wrote:

> Would it make more sense to keep track of three states:
> 
> "Default"
> "Enabled"
> "Disabled"

Well, it is only default on start up, and every jump label is
initialized then to the ideal nop. Either at boot up, or on module load.

What's nice is that the jump label init calls call the "_static" version
of the update (arch_jump_label_transform_static()), and the
enable/disable calls the non "_static" version
(arch_jump_label_transform()). This means that we can set the "init"
flag depending on which way we got into the common code. The upper layer
only needs to know if the field is enabled or disabled. Remember this is
a x86 specific thing. Other archs do not have a different "default" nop.
There's no reason to save a "default" state, as that would require
changing the common arch layers of jump label.

-- Steve




