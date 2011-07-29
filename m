Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1G2SOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:14:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1G2SOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:14:09 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=oZG1OEA3kxQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=G2zMo-8BIjZJ8DWMc7wA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/5] trace: Add per_cpu ring buffer control files
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1311721194-12164-4-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
	 <1311721194-12164-4-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 14:14:07 -0400
Message-ID: <1311963247.21143.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:
> Add a debugfs entry under per_cpu/ folder for each cpu called
> buffer_size_kb to control the ring buffer size for each CPU
> independently.
> 
> If the global file buffer_size_kb is used to set size, the individual
> ring buffers will be adjusted to the given size. The buffer_size_kb will
> report the common size to maintain backward compatibility.
> 
> If the buffer_size_kb file under the per_cpu/ directory is used to
> change buffer size for a specific CPU, only the size of the respective
> ring buffer is updated. When tracing/buffer_size_kb is read, it reports
> the ring buffer sizes of all the CPUs at that point.

No, buffer_size_kb should not change in the what it reports. This is why
you have a buffer_total_size_kb. Use that. If the per_cpu buffers are
changed, then this should just report "various" or something to that
affect. This will be a good way to know if the per_cpu buffers are the
same or not.

-- Steve


