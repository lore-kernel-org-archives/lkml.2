Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2BKLHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 06:07:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51027 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2BKLHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 06:07:46 -0500
MIME-Version: 1.0
In-Reply-To: <4F34D292.4080404@redhat.com>
References: <20120209202938.GA14342@linux.intel.com> <CA+55aFw1=2SR3CtDU_1F_9QJ8OpdGyRRWMbrbvT+COpLWMNO+A@mail.gmail.com>
 <20120209210039.GB14342@linux.intel.com> <4F34D292.4080404@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 11 Feb 2012 12:07:26 +0100
Message-ID: <CAPXgP109Pk_sJFx3KmLM8ehJBodM3N+bAkCBrX6N0JbYL6331w@mail.gmail.com>
Subject: Re: scsi_id: sending ioctl 2285 to a partition
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Doug Nelson <doug.nelson@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 09:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 02/09/2012 10:00 PM, Matthew Wilcox wrote:

>> I'm pretty sure it's doing it as root ... it'll be run by udev, after all.
>
> What does the rule look like?  Here it is like this:
>
> # scsi devices
> KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*",
> IMPORT{program}="scsi_id --export --whitelisted -d $tempnode",
> ENV{ID_BUS}="scsi"
>
> which should exclude partitions, and indeed I don't see any such message.  I
> also have this rule:

I don't think "sd*[!0-9]" matches partition devices.

Kay
