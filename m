Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2BVSFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:05:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2BVSFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:05:39 -0500
Date: Wed, 22 Feb 2012 18:58:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] powerpc/eeh: remove
	eeh_event_handler()->daemonize()
Message-ID: <20120222175847.GA10943@redhat.com>
References: <20120222175703.GA10935@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222175703.GA10935@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Oleg Nesterov wrote:
>
> daemonize() is only needed when a user-space task does kernel_thread().
>
> eeh_event_handler() thread is created by the worker kthread, and thus
> it doesn't need the soon-to-be-deprecated daemonize().

Forgot to mention... Please note that eeh_event_handler() is the last
caller of daemonize(), all other (ab)users are already fixed.

Oleg.

