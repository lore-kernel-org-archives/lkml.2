Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2DJKKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:10:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab2DJKKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:10:40 -0400
Message-ID: <4F840718.1040205@redhat.com>
Date: Tue, 10 Apr 2012 13:10:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        spice-devel <spice-devel@lists.freedesktop.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com>
In-Reply-To: <4F8329D3.7000605@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 09:26 PM, Xiao Guangrong wrote:
> Yes, if Xwindow is not enabled, the benefit is limited. :)

I'm more interested in migration.

We could optimize the framebuffer by disabling dirty logging when
VNC/Spice is not connected (which should usually be the case), or when
the SDL window is minimized (shouldn't be that often, unfortunately)

Related, qxl doesn't seem to stop the dirty log when switching to
accelerated mode.  vmsvga gets it right:

    case SVGA_REG_ENABLE:
        s->enable = value;
        s->config &= !!value;
        s->width = -1;
        s->height = -1;
        s->invalidated = 1;
        s->vga.invalidate(&s->vga);
        if (s->enable) {
            s->fb_size = ((s->depth + 7) >> 3) * s->new_width *
s->new_height;
            vga_dirty_log_stop(&s->vga);
        } else {
            vga_dirty_log_start(&s->vga);
        }
        break;


-- 
error compiling committee.c: too many arguments to function

