Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0LNOjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:39:36 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:58493 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0LNOjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:39:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=TuAc/WQUP6zTg5r3K8VANwIoT8d6PfDIrlYxSg5E+XQRTlVapJ4hA7rtZALx0/Ibtg
         BNSkwbLsSWZa0Z3tffUccy/PaoUqDt0rbd6WeLbG20QeONmTLSBKtmjPUCj8I2jb5mXT
         9Ud4wVbEcQeTJtchtZ/YueycnQGoil/ItQiyY=
Date: Tue, 14 Dec 2010 12:39:29 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "David S. Ahern" <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] perf tools: Add symfs option for off-box analysis
 using specified tree
Message-ID: <20101214143929.GE13425@ghostprotocols.net>
References: <1291926427-28846-1-git-send-email-daahern@cisco.com>
 <20101214122428.GA13425@ghostprotocols.net>
 <20101214125245.GB13425@ghostprotocols.net>
 <20101214140604.GC13425@ghostprotocols.net>
 <4D078037.9060207@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D078037.9060207@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 14, 2010 at 07:33:27AM -0700, David S. Ahern escreveu:
> On 12/14/10 07:06, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Dec 14, 2010 at 10:52:45AM -0200, Arnaldo Carvalho de Melo escreveu:
> >> Ok, there are still some problems:

> >> It is escaping the symfs jail for /home/acme/bin/perf, /lib64/libpthread-2.5.so
> >> and kernel modules, investigating...

> > Those 'G' signals means DSO__ORIG_GUEST_KMODULE, since you were not
> > prefixing that case with symfs, it was the jail leak point, fixed, doing
> > some more testing before merging.

> yuk. I did not touch the hypervisor paths.

> So the 'guest' route is tried all the time because of the origin list --
> even when it's not applicable.

Right, I don't like the way kvm is supported, will revisit this at some
point.

If build-ids were first class citizens, all this would be moot :-\

- Arnaldo
