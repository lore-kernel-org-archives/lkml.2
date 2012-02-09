Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2BIWcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:32:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58035 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab2BIWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:32:53 -0500
Message-ID: <4F344990.7050303@gmail.com>
Date: Thu, 09 Feb 2012 15:32:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, acme@redhat.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com
Subject: Re: [PATCH v6 14/18] perf: fix endianness detection in perf.data
References: <1328826068-11713-1-git-send-email-eranian@google.com> <1328826068-11713-15-git-send-email-eranian@google.com>
In-Reply-To: <1328826068-11713-15-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/2012 03:21 PM, Stephane Eranian wrote:
> The current version of perf detects whether or not
> the perf.data file is written in a different endianness
> using the attr_size field in the header of the file. This
> field represents sizeof(struct perf_event_attr) as known
> to perf record. If the sizes do not match, then perf tries
> the byte-swapped version. If they match, then the tool assumes
> a different endianness.
> 
> The issue with the approach is that it assumes the size of
> perf_event_attr always has to match between perf record and
> perf report. However, the kernel perf_event ABI is extensible.
> New fields can be added to struct perf_event_attr. Consequently,
> it is not possible to use attr_size to detect endianness.
> 
> This patch takes another approach by using the magic number
> written at the beginning of the perf.data file to detect
> endianness. The magic number is an eight-byte signature.
> It's primary purpose is to identify (signature) a perf.data
> file. But it could also be used to encode the endianness.
> 
> The patch introduces a new value for this signature. The key
> difference is that the signature is written differently in
> the file depending on the endianness. Thus, by comparing the
> signature from the file with the tool's own signature it is
> possible to detect endianness. The new signature is "PERFILE2".
> 
> Backward compatiblity with existing perf.data file is
> ensured.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Acked-by: David Ahern <dsahern@gmail.com>

