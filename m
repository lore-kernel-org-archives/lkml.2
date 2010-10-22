Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0JVVrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:47:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50871 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0JVVrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:47:02 -0400
Date: Fri, 22 Oct 2010 14:46:50 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>
Subject: Re: [PATCH 5/7] cgroups: Make freezer subsystem bindable
Message-ID: <20101022214650.GL10119@count0.beaverton.ibm.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
 <4CC1473D.9070201@cn.fujitsu.com>
 <20101022205755.GJ10119@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022205755.GJ10119@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:57:55PM -0700, Matt Helsley wrote:
> On Fri, Oct 22, 2010 at 04:11:41PM +0800, Li Zefan wrote:
> > To make it bindable, we need to thaw all processes when unbinding
> > the freezer subsystem from a cgroup hierarchy.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

<snip>

> 
> Alternately you could split the bind/unbind op function pointers
> and get rid of the boolean argument. Then just don't fill in the
> freezer's unbind op and refuse to unbind subsystems that lack
> the unbind op. That seems a bit cleaner for now at least.

Or alternately to the alternate :):  add a can_unbind:1 field and keep
the boolean bind op argument. That might be best -- avoids an extra
function pointer and still splits the bind/unbind-ability of a
subsystem.

Cheers,
	-Matt Helsley
