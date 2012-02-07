Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2BGU4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:56:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37982 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab2BGU4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:56:43 -0500
Date: Wed, 8 Feb 2012 00:56:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pedro Alves <palves@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120207205639.GJ27437@moon>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
 <20120203162519.GB805@google.com>
 <4F2C0F13.70709@parallels.com>
 <20120203165132.GA5636@redhat.com>
 <4F31848A.9070406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F31848A.9070406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 08:07:38PM +0000, Pedro Alves wrote:
> On 02/03/2012 04:51 PM, Oleg Nesterov wrote:
> > On 02/03, Pavel Emelyanov wrote:
> 
> >> Because there's no need for current to get this value of himself, but can
> >> be useful for e.g. gdb.
> > 
> > OK, perhaps this makes sense, I do not know.
> > 
> > Jan, Pedro, do you think gdb can use PTRACE_GET_TID_ADDRESS (returns
> > tracee->clear_child_tid) ?
> 
> Off hand, I'm not picturing a use.  But that may well just mean I'm lacking
> imagination.  Andrew, Pavel, did you have a particular idea in mind when you
> said it may be useful for debugging a multithreading program / gdb?
> 

Might not we set up hw watchpoint on this address and get interrupt
before pthread-join will find it? (To be fair I'm not sure if such
trick will work, didn't test ;)

	Cyrill
