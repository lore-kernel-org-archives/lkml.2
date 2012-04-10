Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab2DJNP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:15:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60296 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2DJNP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:15:28 -0400
Message-ID: <1334063715.2141.15.camel@hornet>
Subject: Re: [PATCH] init: fix bug where environment vars can't be passed
 via boot args
From: Pawel Moll <pawel.moll@arm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Apr 2012 14:15:15 +0100
In-Reply-To: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com>
References: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com>
X-Mailer: Evolution 3.2.2-
Mime-Version: 1.0
X-OriginalArrivalTime: 10 Apr 2012 13:16:22.0332 (UTC) FILETIME=[1FC7BFC0:01CD171C]
X-MC-Unique: 112041014152501001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 17:53 +0100, Chris Metcalf wrote:
> Commit 026cee0086f had the side-effect of dropping the '=' from
> the unknown boot arguments that are passed to init as environment
> variables.  This is because parse_args() puts a NUL in the string
> where the '=' was when it passes the "param" and "val" pointers
> to the parsing subfunctions.  Previously, unknown_bootoption() was
> the last parse_args() subfunction to run, and it carefully put back
> the '=' character.  Now ignore_unknown_bootoption() is the last
> one to run, and it wasn't doing the necessary repair, so the
> envp params ended up with the embedded NUL and were no longer
> seen as valid environment variables by init.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Looks sensible to me.

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks and apologies about delayed answer (and for causing the problem
in the first place :-)

Paweł


