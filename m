Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0DOGMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:12:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:38744 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab0DOGMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xaBBwNLFsWL/xImmfNElqGsMH32n2phLslL8X6VGLjxId9zq1a6NZ8j4gAOrqZNZF4
         CG+gAITT+K8gJ0mh8mhAmh17w0cXsndjJnclr/ZfnuAxJYGIwTGGgpuoyuBgZ22be7uv
         M5Tc2+d/10T1v34aYvlOrywi9zshte71Bd7g4=
Date: Thu, 15 Apr 2010 08:12:00 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: useless node/has_cpu sysfs attribute
Message-ID: <20100415061200.GC21517@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 99dcc3e5a94ed491fbef402831d8c0bbb267f995 (this_cpu: Page
allocator conversion) removed the call

    node_set_state(node, N_CPU);    /* this node has a cpu */

(in fact process_zones() where this call happened was removed).

Thus the sysfs attribute /sys/devices/system/node/has_cpu doesn't
show anything anymore.

Before this commit the attribute usually listed all nodes ("having a CPU")
in the system, e.g.

  worms linux # cat /sys/devices/system/node/has_cpu
  0-7

This attribute never reflected any changes triggered by CPU hotplug.
I.e. you could set all CPUs of a node offline but the node still was listed
in this attribute. (because no hotplug notifiers exist that would
call node_set_state(node, N_CPU)/node_clear_state(node,N_CPU)).

Do we need this attribute?
Who relies on information from this attribute?

I think if we do not need the attribute we should remove it. But if
there is use for it we need to fix it and make it CPU hotplug aware.

Opinions?


Thanks,

Andreas

PS: The attribute was introduced with commit
bde631a51876f23e9bbdce43f02b7232502c151e (mm: add node states sysfs
class attributeS)
