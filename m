Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1BAJAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:00:31 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:47389 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1BAJAa (ORCPT
	<rfc822;groupwise-MGalbraith@novell.com:0:0>);
	Tue, 1 Feb 2011 04:00:30 -0500
X-Greylist: delayed 1212 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2011 04:00:30 EST
Subject: Re: calling smp_call_function_many() with non-stable CPU mask
From: Mike Galbraith <mgalbraith@novell.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D47D21E020000780002F9FB@novell.com>
References: <4D47D21E020000780002F9FB@novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 09:40:01 +0100
Message-ID: <1296549601.5653.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 09:27 +0100, Jan Beulich wrote:
> There are a couple of examples of smp_call_function_many() getting
> called with mm_cpumask() as the first argument. Since that mask
> generally can change while smp_call_function_many() is executing,
> it seems there might be a problem with the case where that mask
> becomes empty after the initial checks, but before the mask is made
> permanent (by copying into data->cpumask).
> 
> Shouldn't there be a check of data->refs being zero right after
> setting it (to avoid having csd_lock_wait() wait for a remote CPU
> to clear the lock flag, and to avoid adding the entry to
> call_function.queue)?
> 
> If that isn't considered necessary, is it then incorrect to pass
> in-flight CPU masks to smp_call_function_many() (and should
> this requirement then be documented somewhere, and the
> existing calls all be inspected for correctness)?


Freshly baked.

http://www.google.de/url?sa=t&source=web&cd=1&ved=0CBUQFjAA&url=http%3A%
2F%2Flkml.org%2Flkml%2F2011%2F2%2F1%2F18&rct=j&q=PATCH%202%2F3%20v2%5D%
20smp_call_function_many%3A%20handle%20concurrent%20clearing%20of%
20mask&ei=M8ZHTda-LILCswaE6uyVAw&usg=AFQjCNE4M55BFGih2jXsHoAkNd5oTzpQvQ&cad=rja

	-Mike

