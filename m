Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0GVSo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:44:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:5069 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab0GVSo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:44:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=lLxpAPZTWGQSHufT0/ZwE0LUFAWHuVgWICjvLo30B63CUiWcNYEJm10jIeRb0Mp/1
	tcY72ZRnacmcn5cmmC1IA==
MIME-Version: 1.0
In-Reply-To: <20100722183614.GA5443@suse.de>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
Date: Thu, 22 Jul 2010 11:44:50 -0700
Message-ID: <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Paul Menage <menage@google.com>
To: Greg KH <gregkh@suse.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:36 AM, Greg KH <gregkh@suse.de> wrote:
>
> Really?  I see systems mounting it at /cgroups/ in the filesystem today.

Sure, it *can* be mounted as a single instance, but you then lose
flexibility. E.g. at Google we want to have a different hierarchy for
the CPU subsystem (with the tree grouped according to
latency-sensitive versus batch, etc) and memory (grouped according to
what jobs are sharing memory with each other).

> Where are you expecting it to be mounted at?

I have no particular expectation. (At Google we're actually using
/dev/cgroup/* but that's just for historical reasons, from
/dev/cpuset). Under /sys/fs/cgroup sounds reasonable, but you'd want
people to have the ability to manually create subdirs in there for
separate mount points.

Paul
