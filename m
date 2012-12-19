Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2LSMsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:48:11 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37354 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2LSMsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:48:02 -0500
MIME-Version: 1.0
In-Reply-To: <50D1AD38.7070606@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<20121219104722.GA5832@stefanha-thinkpad.redhat.com>
	<50D1AD38.7070606@redhat.com>
Date: Wed, 19 Dec 2012 13:40:57 +0100
Message-ID: <CAJSP0QUNQHSak_jUWA0jfDuKgfVFsyJb0252OxWzQzUcj653bg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of buffers
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, hutao@cn.fujitsu.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 1:04 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 19/12/2012 11:47, Stefan Hajnoczi ha scritto:
>> On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
>> What is the purpose of count_sg?
>
> It is needed to decide whether to use an indirect or a direct buffer.
> The idea is to avoid a memory allocation if the driver is providing us
> with separate sg elements (under the assumption that they will be few).

Ah, this makes sense now.  I saw it affects the decision whether to go
indirect or not but it wasn't obvious why.

> Originally I wanted to use a mix of direct and indirect buffer (direct
> if add_buf received a one-element scatterlist, otherwise indirect).  It
> would have had the same effect, without having to specify count_sg in
> advance.  The spec is not clear if that is allowed or not, but in the
> end they do not work with either QEMU or vhost, so I chose this
> alternative instead.

Okay.

Stefan
