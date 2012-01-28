Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2A1Pc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 10:32:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab2A1Pc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 10:32:57 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv2 02/16] events/hw_event: use __string() trace macros for events
Date: Sat, 28 Jan 2012 13:32:37 -0200
Message-Id: <1327764771-28649-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
References: <1327764771-28649-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some data there uses temporary alloced space. Just attributing
string pointers directly won't work on such cases.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/trace/events/hw_event.h |   78 +++++++++++++++++++-------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
index a46ac61..85fca0d 100644
--- a/include/trace/events/hw_event.h
+++ b/include/trace/events/hw_event.h
@@ -20,17 +20,17 @@ DECLARE_EVENT_CLASS(hw_event_class,
 	TP_ARGS(type, instance),
 
 	TP_STRUCT__entry(
-		__field(	const char *,	type			)
+		__string(	type,		type			)
 		__field(	unsigned int,	instance		)
 	),
 
 	TP_fast_assign(
-		__entry->type	= type;
+		__assign_str(type, type);
 		__entry->instance = instance;
 	),
 
 	TP_printk("Initialized %s#%d\n",
-		__entry->type,
+		__get_str(type),
 		__entry->instance)
 );
 
@@ -70,8 +70,8 @@ TRACE_EVENT(mc_corrected_error,
 		__field(	unsigned long,	syndrome		)
 		__field(	int,		row			)
 		__field(	int,		channel			)
-		__field(	const char *,	label			)
-		__field(	const char *,	msg			)
+		__string(	label,		mci->csrows[row].channels[channel].label)
+		__string(	msg,		msg			)
 	),
 
 	TP_fast_assign(
@@ -82,16 +82,16 @@ TRACE_EVENT(mc_corrected_error,
 		__entry->syndrome		= syndrome;
 		__entry->row			= row;
 		__entry->channel		= channel;
-		__entry->label			= mci->csrows[row].channels[channel].label;
-		__entry->msg			= msg;
+		__assign_str(label, mci->csrows[row].channels[channel].label);
+		__assign_str(msg, msg);
 	),
 
 	TP_printk(HW_ERR "mce#%d: Corrected error %s on label \"%s\" "
 			 "(page 0x%lux, offset 0x%lux, grain %ud, "
 			 "syndrome 0x%lux, row %d, channel %d)\n",
 		__entry->mc_index,
-		__entry->msg,
-		__entry->label,
+		__get_str(msg),
+		__get_str(label),
 		__entry->page_frame_number,
 		__entry->offset_in_page,
 		__entry->grain,
@@ -116,8 +116,8 @@ TRACE_EVENT(mc_uncorrected_error,
 		__field(	unsigned long,	offset_in_page		)
 		__field(	u32,		grain			)
 		__field(	int,		row			)
-		__field(	const char *,	msg			)
-		__field(	const char *,	label			)
+		__string(	msg,		msg			)
+		__string(	label,		label			)
 	),
 
 	TP_fast_assign(
@@ -126,15 +126,15 @@ TRACE_EVENT(mc_uncorrected_error,
 		__entry->offset_in_page		= offset_in_page;
 		__entry->grain			= mci->csrows[row].grain;
 		__entry->row			= row;
-		__entry->msg			= msg;
-		__entry->label			= label;
+		__assign_str(msg, msg);
+		__assign_str(label, label);
 	),
 
 	TP_printk(HW_ERR "mce#%d: Uncorrected error %s on label \"%s\""
 			 "(page 0x%lux, offset 0x%lux, grain %ud, row %d)\n",
 		__entry->mc_index,
-		__entry->msg,
-		__entry->label,
+		__get_str(msg),
+		__get_str(label),
 		__entry->page_frame_number,
 		__entry->offset_in_page,
 		__entry->grain,
@@ -160,23 +160,23 @@ TRACE_EVENT(mc_corrected_error_fbd,
 		__field(	unsigned int,	mc_index		)
 		__field(	int,		row			)
 		__field(	int,		channel	        	)
-		__field(	const char *,	label			)
-		__field(	const char *,	msg			)
+		__string(	label,		mci->csrows[row].channels[channel].label)
+		__string(	msg,		msg			)
 	),
 
 	TP_fast_assign(
 		__entry->mc_index		= mci->mc_idx;
 		__entry->row			= row;
 		__entry->channel		= channel;
-		__entry->label			= mci->csrows[row].channels[channel].label;
-		__entry->msg			= msg;
+		__assign_str(label, mci->csrows[row].channels[channel].label);
+		__assign_str(msg, msg);
 	),
 
 	TP_printk(HW_ERR "mce#%d: Corrected Error %s on label \"%s\" "
 			 "(row %d, channel %d)\n",
 		__entry->mc_index,
-		__entry->msg,
-		__entry->label,
+		__get_str(msg),
+		__get_str(label),
 		__entry->row,
 		__entry->channel)
 );
@@ -194,8 +194,8 @@ TRACE_EVENT(mc_uncorrected_error_fbd,
 		__field(	int,		row			)
 		__field(	int,		channela		)
 		__field(	int,		channelb		)
-		__field(	const char *,	msg			)
-		__field(	const char *,	label			)
+		__string(	msg,		msg			)
+		__string(	label,		label			)
 	),
 
 	TP_fast_assign(
@@ -203,15 +203,15 @@ TRACE_EVENT(mc_uncorrected_error_fbd,
 		__entry->row			= row;
 		__entry->channela		= channela;
 		__entry->channelb		= channelb;
-		__entry->msg			= msg;
-		__entry->label			= label;
+		__assign_str(msg, msg);
+		__assign_str(label, label);
 	),
 
 	TP_printk(HW_ERR "mce#%d: Uncorrected Error %s on label \"%s\" "
 			 "(row %d, channels: %d, %d)\n",
 		__entry->mc_index,
-		__entry->msg,
-		__entry->label,
+		__get_str(msg),
+		__get_str(label),
 		__entry->row,
 		__entry->channela,
 		__entry->channelb)
@@ -236,8 +236,8 @@ TRACE_EVENT(mc_out_of_range,
 	TP_ARGS(mci, type, field, invalid_val, min, max),
 
 	TP_STRUCT__entry(
-		__field(	const char *,	type			)
-		__field(	const char *,	field			)
+		__string(	type,		type			)
+		__string(	field,		field			)
 		__field(	unsigned int,	mc_index		)
 		__field(	int,		invalid_val		)
 		__field(	int,		min			)
@@ -245,8 +245,8 @@ TRACE_EVENT(mc_out_of_range,
 	),
 
 	TP_fast_assign(
-		__entry->type			= type;
-		__entry->field			= field;
+		__assign_str(type, type);
+		__assign_str(field, field);
 		__entry->mc_index		= mci->mc_idx;
 		__entry->invalid_val		= invalid_val;
 		__entry->min			= min;
@@ -255,8 +255,8 @@ TRACE_EVENT(mc_out_of_range,
 
 	TP_printk(HW_ERR "mce#%d %s: %s=%d is not between %d and %d\n",
 		__entry->mc_index,
-		__entry->type,
-		__entry->field,
+		__get_str(type),
+		__get_str(field),
 		__entry->invalid_val,
 		__entry->min,
 		__entry->max)
@@ -274,18 +274,18 @@ TRACE_EVENT(mc_corrected_error_no_info,
 	TP_ARGS(mci, msg),
 
 	TP_STRUCT__entry(
-		__field(	const char *,	msg			)
+	__string(	msg,			msg			)
 		__field(	unsigned int,	mc_index		)
 	),
 
 	TP_fast_assign(
-		__entry->msg			= msg;
+		__assign_str(msg, msg);
 		__entry->mc_index		= mci->mc_idx;
 	),
 
 	TP_printk(HW_ERR "mce#%d: Corrected Error: %s\n",
 		__entry->mc_index,
-		__entry->msg)
+		__get_str(msg))
 );
 
 TRACE_EVENT(mc_uncorrected_error_no_info,
@@ -294,18 +294,18 @@ TRACE_EVENT(mc_uncorrected_error_no_info,
 	TP_ARGS(mci, msg),
 
 	TP_STRUCT__entry(
-		__field(	const char *,	msg			)
+		__string(	msg,		msg			)
 		__field(	unsigned int,	mc_index		)
 	),
 
 	TP_fast_assign(
-		__entry->msg			= msg;
+		__assign_str(msg, msg);
 		__entry->mc_index		= mci->mc_idx;
 	),
 
 	TP_printk(HW_ERR "mce#%d: Uncorrected Error: %s\n",
 		__entry->mc_index,
-		__entry->msg)
+		__get_str(msg))
 );
 
 
-- 
1.7.8

