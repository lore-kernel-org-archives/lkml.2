Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2CLE6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 00:58:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61896 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2CLE6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 00:58:02 -0400
Date: Sun, 11 Mar 2012 23:57:49 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Prashanth K Nageshappa <prashanth@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [ 29/68] kprobes: return proper error code from register_kprobe()
Message-ID: <20120312045749.GA15945@burratino>
References: <20120309194409.GA2069@kroah.com>
 <20120309190217.319548473@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309190217.319548473@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg KH wrote:

> 3.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
>
> commit f986a499ef6f317d906e6f6f281be966e1237a10 upstream.

Looks good for 3.2.y.

This is a pointless no-op in 3.0.y, since it doesn't include commit
bc81d48d13d8 (kprobes: Return -ENOENT if probe point doesn't exist,
2011-06-29).

[...]
> This patch fixes it by returning -EINVAL upon failure.
[...]
> @@ -1396,7 +1398,7 @@ out:
>  
>  	return ret;
>  
> -fail_with_jump_label:
> +cannot_probe:
>  	preempt_enable();
>  	jump_label_unlock();
>  	return -EINVAL;

Hope that helps,
Jonathan
