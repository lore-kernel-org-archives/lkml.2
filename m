Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0KWVi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:38:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43570 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0KWVi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:38:26 -0500
Message-ID: <4CEC33F6.9090808@zytor.com>
Date: Tue, 23 Nov 2010 13:36:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: rostedt@goodmis.org, mingo@elte.hu, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
References: <cover.1290546539.git.jbaron@redhat.com>
In-Reply-To: <cover.1290546539.git.jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 01:27 PM, Jason Baron wrote:
> Hi,
> 
> A few jump label patches that I want considered for 2.6.37. Patches are against
> the latest -tip tree.
> 
> The first one, which adds 'state' to the jump label mechanism is the most
> important. Essentially, it ensures that if jump labels are enabled/disabled in
> the core kernel but the actual call sites are in modules, we properly honor the
> state of the jump label. This also works for jump labels which may be defined in
> one module but made use of in another module.
> 
> There has been some discussion about using the 'key' variable to store the
> enabled/disabled state for each jump label. However, I think a better design
> will be to use the 'key' variable to store a pointer to the appropriate jump
> label tables. In this way, we can enable/disable jump labels, without the
> hashing that I'm currently doing. However, I didn't want to propose these more
> invasive changes until 2.6.38. 
> 

I would also like to see a change in the API, preferrably something
closer to the "SWITCH_POINT" interface I discussed with Stephen before
Kernel Summit.

	-hpa
