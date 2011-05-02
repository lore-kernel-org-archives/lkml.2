Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1EBRgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:36:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49713 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab1EBRgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:36:52 -0400
Subject: Re: [PATCH] flex_array: avoid divisions when accessing elements
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jesse Gross <jesse@nicira.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1304357194-19308-1-git-send-email-eparis@redhat.com>
References: <1304357194-19308-1-git-send-email-eparis@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 02 May 2011 10:36:45 -0700
Message-ID: <1304357805.30823.18.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 13:26 -0400, Eric Paris wrote:
> On most architectures division is an expensive operation and accessing an
> element currently requires four of them.  This performance penalty
> effectively precludes flex arrays from being used on any kind of fast
> path.  However, two of these divisions can be handled at creation time and
> the others can be replaced by a reciprocal divide, completely avoiding
> real divisions on access.
> 
> Signed-off-by: Jesse Gross <jesse@nicira.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Eric Paris <eparis@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [rebase on top of changes to support 0 len elements: eparis]
> [initialize part_nr when array fits entirely in base: eparis]
> Signed-off-by: Eric Paris <eparis@redhat.com> 

This seems sane to me, especially in the element access case.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

