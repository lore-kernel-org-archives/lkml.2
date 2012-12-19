Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2LSME1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:04:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2LSMET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:04:19 -0500
Message-ID: <50D1AD38.7070606@redhat.com>
Date: Wed, 19 Dec 2012 13:04:08 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
 buffers
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com> <1355833972-20319-2-git-send-email-pbonzini@redhat.com> <20121219104722.GA5832@stefanha-thinkpad.redhat.com>
In-Reply-To: <20121219104722.GA5832@stefanha-thinkpad.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/12/2012 11:47, Stefan Hajnoczi ha scritto:
> On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
>> +/**
>> + * virtqueue_start_buf - start building buffer for the other end
>> + * @vq: the struct virtqueue we're talking about.
>> + * @buf: a struct keeping the state of the buffer
>> + * @data: the token identifying the buffer.
>> + * @count: the number of buffers that will be added
> 
> Perhaps count should be named count_bufs or num_bufs.

Ok.

>> + * @count_sg: the number of sg lists that will be added
> 
> What is the purpose of count_sg?

It is needed to decide whether to use an indirect or a direct buffer.
The idea is to avoid a memory allocation if the driver is providing us
with separate sg elements (under the assumption that they will be few).

Originally I wanted to use a mix of direct and indirect buffer (direct
if add_buf received a one-element scatterlist, otherwise indirect).  It
would have had the same effect, without having to specify count_sg in
advance.  The spec is not clear if that is allowed or not, but in the
end they do not work with either QEMU or vhost, so I chose this
alternative instead.

Paolo


> Stefan
> 

