Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0KSSCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:02:41 -0500
Received: from ns1.cypress.com ([157.95.67.4]:38179 "EHLO ns1.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0KSSCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:02:39 -0500
X-Greylist: delayed 952 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 13:02:38 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
Date: Fri, 19 Nov 2010 09:39:42 -0800
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC090119784D@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
Thread-Index: AcuE5M9bPLRT89KmSKCVc8A8+5t7lQDKUJoQ
References: <Kevin McNeely <kev@cypress.com> <1289327120-2612-1-git-send-email-kev@cypress.com> <4CE163CC.1060202@euromail.se>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        "Luotao Fu" <l.fu@pengutronix.de>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Nov 2010 17:39:43.0774 (UTC) FILETIME=[C05373E0:01CB8810]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henrik,

Thank you for reviewing this code submission.

I have replied to each of your comments below.

I would like to resubmit to include the changes.

Thanks and best regards,
Kevin


> -----Original Message-----
> From: Henrik Rydberg [mailto:rydberg@euromail.se]
> Sent: Monday, November 15, 2010 8:46 AM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Samuel Ortiz; Eric
Miao;
> Simtec Linux Team; Luotao Fu; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
> 
> On 11/09/2010 07:25 PM, Kevin McNeely wrote:
> 
> > Initial release of Cypress TTSP Gen3 Core Driver.
> > Core Driver includes platform data definition file,
> > core driver definition file, and core touchscreen
> > touch handling of device data. Generates
> > multi-touch input events.
> >
> > Signed-off-by: Kevin McNeely <kev@cypress.com>
> 
> > ---
> 
> 
> Thanks for your submission. Please find comments on MT inline. On a
> general
> note, it is strongly recommended that this driver be converted to the
> MT slots
> (type B) protocol.

I will resubmit with Protocol A only at this time.  I will remove the
Tracking ID's.

> 
> > +
> > +/* TrueTouch Standard Product Gen3 interface definition */
> > +struct cyttsp_xydata {
> > +	u8 hst_mode;
> > +	u8 tt_mode;
> > +	u8 tt_stat;
> > +	struct cyttsp_touch tch1;
> > +	u8 touch12_id;
> > +	struct cyttsp_touch tch2;
> > +	u8 gest_cnt;
> > +	u8 gest_id;
> > +	struct cyttsp_touch tch3;
> > +	u8 touch34_id;
> > +	struct cyttsp_touch tch4;
> > +	u8 tt_undef[3];
> > +	u8 gest_set;
> 
> 
> I take it the gesture functionality is not in use in this driver?

Correct, I will remove all instances and mentions of the gesture. The
field of interest is the active distance for touches.

> 
> > +	u8 tt_reserved;
> > +};
> > +
> > +
> > +struct cyttsp_tch {
> > +	struct cyttsp_touch *tch;
> > +	u8 *id;
> > +};
> 
> 
> Given how this mapping is used, it could possibly be dropped
> altogether. See
> further comment on cyttsp_init_tch_map().

The mapping is to allow number of touch growth with extra register
information. The mapping is to allow looping on the touch processing.

> 
> > +
> 
> > +struct cyttsp_trk {
> > +	u8 tch;
> > +	u8 w;
> 
> 
> It seems the device does not report contact width, so it is better not
> reported
> at all.

The width will be removed.

> 
> > +	u16 x;
> > +	u16 y;
> > +	u8 z;
> > +};
> > +
> > +struct cyttsp {
> > +	struct device *dev;
> > +	int irq;
> > +	struct input_dev *input;
> > +	struct mutex mutex;
> > +	char phys[32];
> > +	struct bus_type *bus_type;
> > +	struct cyttsp_platform_data *platform_data;
> > +	struct cyttsp_xydata xy_data;
> > +	struct cyttsp_bootloader_data bl_data;
> > +	struct cyttsp_sysinfo_data sysinfo_data;
> > +	struct cyttsp_trk prv_trk[CY_NUM_TRK_ID];
> 
> 
> Apart from the ids, what information is used from the previous frame?

The previous X, Y.

> 
> > +static int cyttsp_gesture_setup(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +	u8 gesture_setup;
> > +
> > +	/* Init gesture; active distance setup */
> > +	gesture_setup = ts->platform_data->gest_set;
> > +	retval = ttsp_write_block_data(ts, CY_REG_GEST_SET,
> > +		sizeof(gesture_setup), &gesture_setup);
> > +
> > +	return retval;
> > +}
> 
> 
> What does this initialization actually do?

This will be replaced with an active distance setup function, which is
the sole intent of the current gesture setup function.  We are really
just initializing the active distance field.

> 
> > +
> > +static void cyttsp_init_tch_map(struct cyttsp *ts)
> > +{
> > +	ts->tch_map[0].tch = &ts->xy_data.tch1;
> > +	ts->tch_map[0].id = &ts->xy_data.touch12_id;
> > +	ts->tch_map[1].tch = &ts->xy_data.tch2;
> > +	ts->tch_map[1].id = &ts->xy_data.touch12_id;
> > +	ts->tch_map[2].tch = &ts->xy_data.tch3;
> > +	ts->tch_map[2].id = &ts->xy_data.touch34_id;
> > +	ts->tch_map[3].tch = &ts->xy_data.tch4;
> > +	ts->tch_map[3].id = &ts->xy_data.touch34_id;
> > +}
> 
> 
> Calling cyttsp_get_xydata() four times with special arguments would
> make this
> function unnecessary.

The cyttsp_get_xydata() makes a single I2C read transaction which
contains touch information for all touches currently tracked by the
device.

> 
> > +
> > +static void handle_multi_touch(struct cyttsp_track_data *t, struct
> cyttsp *ts)
> > +{
> > +	u8 id;
> > +	u8 cnt = 0;
> > +
> > +	/* terminate any previous touch where the track
> > +	 * is missing from the current event
> > +	 */
> > +	for (id = 0; id < CY_NUM_TRK_ID; id++) {
> > +		if (t->cur_trk[id].tch) {
> > +			/* put active current track data */
> > +			input_report_abs(ts->input,
> > +				ABS_MT_TRACKING_ID, id);
> 
> > +			input_report_abs(ts->input,
> > +				ABS_MT_WIDTH_MAJOR, t->cur_trk[id].w);
> 
> 
> This value does not seem to be reported by the device and should be
> dropped.

This will be dropped.

> 
> > +			input_report_abs(ts->input,
> > +				ABS_MT_POSITION_X, t->cur_trk[id].x);
> > +			input_report_abs(ts->input,
> > +				ABS_MT_POSITION_Y, t->cur_trk[id].y);
> > +			input_report_abs(ts->input,
> > +				ABS_MT_TOUCH_MAJOR, t->cur_trk[id].z);
> > +			input_mt_sync(ts->input);
> > +
> > +			dev_dbg(ts->dev, "%s: MT1: X=%d Y=%d Z=%d\n",
> > +				__func__,
> > +				t->cur_trk[id].x,
> > +				t->cur_trk[id].y,
> > +				t->cur_trk[id].z);
> > +			/* save current track data into previous track
data
> */
> > +			ts->prv_trk[id] = t->cur_trk[id];
> > +			cnt++;
> > +		} else if (ts->prv_trk[id].tch) {
> > +			/* put lift-off previous track data */
> > +			input_report_abs(ts->input,
> > +				ABS_MT_TRACKING_ID, id);
> 
> 
> Reporting tracking id here unfortunately does not work very well. With
> the type
> A protocol, ids not reported will automatically be removed, and

This will be Protocol A only. The Track Id reporting will be removed.

> 
> > +			input_report_abs(ts->input,
> > +				ABS_MT_WIDTH_MAJOR, ts->prv_trk[id].w);
> > +			input_report_abs(ts->input,
> > +				ABS_MT_POSITION_X, ts->prv_trk[id].x);
> > +			input_report_abs(ts->input,
> > +				ABS_MT_POSITION_Y, ts->prv_trk[id].y);
> > +			input_report_abs(ts->input,
> > +				ABS_MT_TOUCH_MAJOR, CY_NTCH);
> 
> 
> checking for zero touch like this only applies for drivers not
> reporting
> tracking id.

This will now be necessary for Protocol A only.

> 
> > +			input_mt_sync(ts->input);
> > +
> > +			dev_dbg(ts->dev, "%s: MT1: X=%d Y=%d Z=%d lift-
> off\n",
> > +				__func__,
> > +				ts->prv_trk[id].x,
> > +				ts->prv_trk[id].y,
> > +				CY_NTCH);
> > +			ts->prv_trk[id].tch = CY_NTCH;
> > +			cnt++;
> > +		}
> > +	}
> > +
> > +	/* signal the view motion event */
> > +	if (cnt)
> > +		input_sync(ts->input);
> > +}
> 
> 
> Since the device does its own tracking, the driver would benefit
> greatly from
> using the type B protocol.

Current requests are for Protocol A only.  Cypress will followup with a
Protocol B driver submission.

> 
> > +static int cyttsp_xy_worker(struct cyttsp *ts)
> > +{
> > +	u8 cur_tch = 0;
> > +	u8 tch;
> > +	struct cyttsp_track_data trk;
> > +
> > +	/* get event data from CYTTSP device */
> > +	if (ttsp_read_block_data(ts,
> > +		CY_REG_BASE, sizeof(struct cyttsp_xydata),
&ts->xy_data))
> > +		return 0;
> > +
> > +	/* touch extension handling */
> > +	if (ttsp_tch_ext(ts, &ts->xy_data))
> > +		return 0;
> > +
> > +	/* provide flow control handshake */
> > +	if (ts->platform_data->use_hndshk)
> > +		if (cyttsp_hndshk(ts, ts->xy_data.hst_mode))
> > +			return 0;
> > +
> > +	cur_tch = GET_NUM_TOUCHES(ts->xy_data.tt_stat);
> > +
> > +	if (ts->bus_ops->power_state == CY_IDLE_STATE)
> > +		return 0;
> > +	else if (GET_BOOTLOADERMODE(ts->xy_data.tt_mode)) {
> > +		return -1;
> > +	} else if (IS_LARGE_AREA(ts->xy_data.tt_stat) == 1) {
> > +		/* terminate all active tracks */
> > +		cur_tch = CY_NTCH;
> > +		dev_dbg(ts->dev, "%s: Large area detected\n", __func__);
> > +	} else if (cur_tch > CY_NUM_TCH_ID) {
> > +		/* terminate all active tracks */
> > +		cur_tch = CY_NTCH;
> > +		dev_dbg(ts->dev, "%s: Num touch error detected\n",
> __func__);
> > +	} else if (IS_BAD_PKT(ts->xy_data.tt_mode)) {
> > +		/* terminate all active tracks */
> > +		cur_tch = CY_NTCH;
> > +		dev_dbg(ts->dev, "%s: Invalid buffer detected\n",
> __func__);
> > +	}
> > +
> > +	/* process the touches */
> > +	cyttsp_init_cur_trks(&trk);
> > +
> > +	for (tch = 0; tch < cur_tch; tch++) {
> > +		cyttsp_get_xydata(ts, &trk,
> > +			tch & 0x01 ?
> > +			(*(ts->tch_map[tch].id) & 0x0F) :
> > +			(*(ts->tch_map[tch].id) & 0xF0) >> 4,
> > +			CY_SMALL_TOOL_WIDTH,
> 
> > +			be16_to_cpu((ts->tch_map[tch].tch)->x),
> > +			be16_to_cpu((ts->tch_map[tch].tch)->y),
> > +			(ts->tch_map[tch].tch)->z);
> > +	}
> 
> 
> How about expanding this loop with special arguments instead?

The mapping method is intended to hide the offset information in the
current registry and be extensible for future updates for more touches.

> 
> > +/*
> > + * Active distance in pixels for a gesture to be reported
> > + * if set to 0, then all gesture movements are reported
> > + * Valid range is 0 - 15
> > + */
> > +#define CY_ACT_DIST_DFLT 8
> > +#define CY_ACT_DIST CY_ACT_DIST_DFLT
> 
> 
> These do not seem to be used anywhere.

This will be refined and added to the code which checks for valid
operational mode.

> 
> > +
> > +enum cyttsp_gest {
> > +	CY_GEST_GRP_NONE = 0,
> > +	CY_GEST_GRP1 =	0x10,
> > +	CY_GEST_GRP2 = 0x20,
> > +	CY_GEST_GRP3 = 0x40,
> > +	CY_GEST_GRP4 = 0x80,
> > +};
> 
> 
> Neither do these.

These will be removed.

> 
> Thanks,
> Henrik

Thanks again for your review.
Best regards,
Kevin


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

