Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1JTQQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:16:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43962 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab1JTQQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <20111020161123.GW25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org> <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com> <20111019165932.GH1140@redhat.com>
 <20111019220553.GQ25124@google.com> <20111019220717.GR25124@google.com>
 <20111019235146.GS25124@google.com> <20111020134137.GA13685@redhat.com> <20111020161123.GW25124@google.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 20 Oct 2011 18:16:04 +0200
Message-ID: <CAPXgP12hvveG8y31Q77BQAzrdaeaux=Eoonu8RinGmP3DfTsbQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in blkio_policy_parse_and_set()
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 18:11, Tejun Heo <tj@kernel.org> wrote:
> I think this is essentially a bug.  If you have something like "dev =
> find_and_get(); put(dev); return dev != NULL;", it's a pretty good
> indication something is pretty screwed there, so unless someone
> screams really loud, I think I'm gonna push for removal of the
> feature.

Matching on unpredictable dev_t inside the kernel or in userspace is a
serious bug. We can't do anything like that ever on a modern system,
these times are long over.

Yes, please get rid of this misguided logic, nobody should get the
impression that this can ever work.

Kay
