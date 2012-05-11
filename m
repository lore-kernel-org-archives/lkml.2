Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab2EKU0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:26:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40099 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2EKU0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:26:21 -0400
MIME-Version: 1.0
Date: Fri, 11 May 2012 13:26:20 -0700
Message-ID: <CACE2HEAC3EsV1XMRRg_cvXYN6GMT2yppS+NPOHoC51SxO3vPAA@mail.gmail.com>
Subject: TRACE_* macros and #ifdef guards
From: John Sheu <john.sheu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been poking at the linux kernel events tracing, am seeing some
inconsistencies in the usage of the TRACE_* macros.

For example, samples/trace_events/trace-events.sample.h has the entire
block below outside #ifdef guards:


#undef TRACE_INCLUDE_PATH
#undef TRACE_INCLUDE_FILE
#define TRACE_INCLUDE_PATH .
/*
 * TRACE_INCLUDE_FILE is not needed if the filename and TRACE_SYSTEM are equal
 */
#define TRACE_INCLUDE_FILE trace-events-sample
#include <trace/define_trace.h>


This is the case for most usages of trace events.  Some drivers (e.g.
drm), though, have part of the block inside the #ifdef guard:


#undef TRACE_SYSTEM
#define TRACE_SYSTEM drm
#define TRACE_SYSTEM_STRING __stringify(TRACE_SYSTEM)
#define TRACE_INCLUDE_FILE drm_trace
<snip>
#endif /* _DRM_TRACE_H_ */
/* This part must be outside protection */
#undef TRACE_INCLUDE_PATH
#define TRACE_INCLUDE_PATH .
#include <trace/define_trace.h>


Can I assume that using the TRACE_* macros inside the #ifdef guards is
incorrect (e.g. in drm), and should be corrected?

Thanks,
-John Sheu
