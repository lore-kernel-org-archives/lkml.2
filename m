Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1DFTV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:21:28 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56909 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab1DFTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:21:27 -0400
Date: Wed, 6 Apr 2011 12:21:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110406192119.GB2265@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D931814.9090100@suse.cz>
 <4D93D29C.5010702@cn.fujitsu.com>
 <1301558691.2250.486.camel@laptop>
 <4D944E60.8080704@cn.fujitsu.com>
 <1301570320.4859.242.camel@twins>
 <4D953121.6090901@cn.fujitsu.com>
 <1301657749.4859.531.camel@twins>
 <20110405215450.GK2247@linux.vnet.ibm.com>
 <20110405230745.GA5972@linux.vnet.ibm.com>
 <1302077428.2225.1365.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302077428.2225.1365.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 10:10:28AM +0200, Peter Zijlstra wrote:
> On Tue, 2011-04-05 at 16:07 -0700, Paul E. McKenney wrote:
> > 
> > The next layer on this onion is the use of the ctl_table typedef
> > in include/linux/key.h -- which is defined to be struct ctl_table.
> > Anyone know where struct ctl_table is defined?  Color me blind, but I
> > am not seeing it... 
> 
> include/linux/sysctl.h:1015

Thank you!

							Thanx, Paul

> /* A sysctl table is an array of struct ctl_table: */
> struct ctl_table
> {
>         const char *procname;           /* Text ID for /proc/sys, or zero */
>         void *data;
>         int maxlen;
>         mode_t mode;
>         struct ctl_table *child;
>         struct ctl_table *parent;       /* Automatically set */
>         proc_handler *proc_handler;     /* Callback for text formatting */
>         void *extra1;
>         void *extra2;
> };
> 
