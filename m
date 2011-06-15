Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1FOOZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:25:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64269 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab1FOOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KNtFVyFNNufjcsxHZoW1VFEQqEjN2/+bEce+oys322RHlR7YpDlOoq9XkThLNlPbmj
         HKVLTdh/xf05PuC47HCEBVrBk1a4LRF6DJpHnQAn9G7PJ2D6y3PY8kOrNKms41LI/6pY
         Kqy0d4nANMggirf46FEoW2BU9A9Zdcvzb3s/g=
Date: Wed, 15 Jun 2011 16:25:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [PATCH 03/16 v2] tracing: Add a proc file to stop tracing and
 free buffer
Message-ID: <20110615142523.GA17204@somewhere>
References: <20110615134841.767565350@goodmis.org>
 <20110615135233.415290242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615135233.415290242@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 09:48:44AM -0400, Steven Rostedt wrote:
> From: Vaibhav Nagarnaik <vnagarnaik@google.com>
> 
> The proc file entry buffer_size_kb is used to set the size of tracing
> buffer.
>
> The memory to expand the buffer size is kernel memory. Consider
> a use case where tracing is handled by a user space utility, which acts
> as a gate keeper for tracing requests. In an OOM condition, tracing is
> considered a low priority task and if the utility gets killed the ring
> buffer memory cannot be released back to the kernel.
> 
> This patch adds a proc file called "free_buffer" whose purpose is to
> stop tracing and free up the ring buffer when it is closed.
> 
> The user space process can then set the desired size in buffer_size_kb
> file and open the fd to the "free_buffer" file. Under OOM condition, if
> the process gets killed, the kernel closes the file descriptor. The
> release handler stops the tracing and releases the kernel memory
> automatically.
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Michael Rubin <mrubin@google.com>
> Cc: David Sharp <dhsharp@google.com>
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> Link: http://lkml.kernel.org/r/1308012717-11148-1-git-send-email-vnagarnaik@google.com
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

s/proc/debugfs, right?
