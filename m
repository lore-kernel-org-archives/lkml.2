Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2DSTzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:55:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44559 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2DSTy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:54:59 -0400
MIME-Version: 1.0
In-Reply-To: <201204191438.54221.hverkuil@xs4all.nl>
References: <1334765203-31844-1-git-send-email-manjunatha_halli@ti.com>
 <1334765203-31844-5-git-send-email-manjunatha_halli@ti.com> <201204191438.54221.hverkuil@xs4all.nl>
From: halli manjunatha <hallimanju@gmail.com>
Date: Thu, 19 Apr 2012 14:54:37 -0500
Message-ID: <CAMT6PycVBt6Da0RbmhqfVXbND_CFmSBsv_yaTrH+VEgx1=6gKw@mail.gmail.com>
Subject: Re: [PATCH V2 4/5] [Documentation] Media: Update docs for V4L2 FM new features
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, benzyg@ti.com, linux-kernel@vger.kernel.org,
        Manjunatha Halli <x0130808@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 7:38 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Manjunatha,
>
> A quick review:
>
> On Wednesday, April 18, 2012 18:06:42 manjunatha_halli@ti.com wrote:
>> From: Manjunatha Halli <x0130808@ti.com>
>>
>> The list of new features -
>>       1) New control class for FM RX
>>       2) New FM RX CID's - De-Emphasis filter mode and RDS AF switch
>>       3) New FM TX CID - RDS Alternate frequency set.
>>
>> Signed-off-by: Manjunatha Halli <x0130808@ti.com>
>> ---
>>  Documentation/DocBook/media/v4l/compat.xml         |    3 +
>>  Documentation/DocBook/media/v4l/controls.xml       |   78 ++++++++++++++++++++
>>  Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
>>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 ++
>>  4 files changed, 91 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
>> index bce97c5..df1f345 100644
>> --- a/Documentation/DocBook/media/v4l/compat.xml
>> +++ b/Documentation/DocBook/media/v4l/compat.xml
>> @@ -2311,6 +2311,9 @@ more information.</para>
>>         <para>Added FM Modulator (FM TX) Extended Control Class: <constant>V4L2_CTRL_CLASS_FM_TX</constant> and their Control IDs.</para>
>>       </listitem>
>>       <listitem>
>> +     <para>Added FM Receiver (FM RX) Extended Control Class: <constant>V4L2_CTRL_CLASS_FM_RX</constant> and their Control IDs.</para>
>> +     </listitem>
>> +     <listitem>
>>         <para>Added Remote Controller chapter, describing the default Remote Controller mapping for media devices.</para>
>>       </listitem>
>>        </orderedlist>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index b84f25e..f6c8034 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -3018,6 +3018,12 @@ to find receivers which can scroll strings sized as 32 x N or 64 x N characters.
>>  with steps of 32 or 64 characters. The result is it must always contain a string with size multiple of 32 or 64. </entry>
>>         </row>
>>         <row>
>> +       <entry spanname="id"><constant>V4L2_CID_RDS_TX_AF_FREQ</constant>&nbsp;</entry>
>> +       <entry>integer</entry>
>> +       </row>
>> +       <row><entry spanname="descr">Sets the RDS Alternate Frequency value which allows a receiver to re-tune to a different frequency providing the same station when the first signal becomes too weak (e.g., when moving out of range). </entry>
>
> What is the unit of this frequency? I assume that is defined in the RDS standard?
AFs for the tuned network are broadcast two codes at a time, in block
3 of type 0A groups, so driver has to parse the 0A group of the
received RDS message and store the found AF frequency separately.
Once the RSSI level or current channel goes below certain threshold
driver will try to switch to stored AF frequency.
>
>> +       </row>
>> +       <row>
>>           <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_ENABLED</constant>&nbsp;</entry>
>>           <entry>boolean</entry>
>>         </row>
>> @@ -3146,6 +3152,78 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
>>  <xref linkend="en50067" /> document, from CENELEC.</para>
>>      </section>
>>
>> +    <section id="fm-rx-controls">
>> +      <title>FM Receiver Control Reference</title>
>> +
>> +      <para>The FM Receiver (FM_RX) class includes controls for common features of
>> +FM Reception capable devices. Currently this class includes parameter for Alternate
>> +frequency.</para>
>> +
>> +      <table pgwide="1" frame="none" id="fm-rx-control-id">
>> +      <title>FM_RX Control IDs</title>
>> +
>> +      <tgroup cols="4">
>> +        <colspec colname="c1" colwidth="1*" />
>> +        <colspec colname="c2" colwidth="6*" />
>> +        <colspec colname="c3" colwidth="2*" />
>> +        <colspec colname="c4" colwidth="6*" />
>> +        <spanspec namest="c1" nameend="c2" spanname="id" />
>> +        <spanspec namest="c2" nameend="c4" spanname="descr" />
>> +        <thead>
>> +          <row>
>> +            <entry spanname="id" align="left">ID</entry>
>> +            <entry align="left">Type</entry>
>> +          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
>> +          </row>
>> +        </thead>
>> +        <tbody valign="top">
>> +          <row><entry></entry></row>
>> +          <row>
>> +            <entry spanname="id"><constant>V4L2_CID_FM_RX_CLASS</constant>&nbsp;</entry>
>> +            <entry>class</entry>
>> +          </row><row><entry spanname="descr">The FM_RX class
>> +descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
>> +description of this control class.</entry>
>> +          </row>
>> +          <row>
>> +            <entry spanname="id"><constant>V4L2_CID_RDS_AF_SWITCH</constant>&nbsp;</entry>
>> +            <entry>boolean</entry>
>> +          </row>
>> +          <row><entry spanname="descr">Enable or Disable's FM RX RDS Alternate frequency feature.</entry>
>
> How does this work? If this is enabled, will the receiver automagically switch to
> the alternate frequency if the signal becomes too weak? And how does that affect
> VIDIOC_G_FREQUENCY?

Yes, when signal strength of current channel goes below the threshold
then driver will switch to the AF frequency and updates the
VIDIOC_G_FREQUENCY accordingly.
>
>> +          </row>
>> +          <row>
>> +         <entry spanname="id"><constant>V4L2_CID_TUNE_DEEMPHASIS</constant>&nbsp;</entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row id="v4l2-deemphasis"><entry spanname="descr">Configures the de-emphasis value for reception.
>> +A pre-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
>> +Depending on the region, a time constant of either 50 or 75 useconds is used. The enum&nbsp;v4l2_deemphasis
>> +defines possible values for pre-emphasis. Here they are:</entry>
>
> Should enum v4l2_preemphasis be reused here? I'm not certain what's best myself.

Sure we can use the same enum for both FM RX and TX, but shall I name
it as "enum v4l2_emphasis_filter" (as in case of RX its de-emphasis
and in TX its Pre-Emphasis)

>
>> +     </row><row>
>> +     <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +                 <row>
>> +                   <entry><constant>V4L2_DEEMPHASIS_DISABLED</constant>&nbsp;</entry>
>> +                   <entry>No de-emphasis is applied.</entry>
>> +                 </row>
>> +                 <row>
>> +                   <entry><constant>V4L2_DEEMPHASIS_50_uS</constant>&nbsp;</entry>
>> +                   <entry>A de-emphasis of 50 uS is used.</entry>
>> +                 </row>
>> +                 <row>
>> +                   <entry><constant>V4L2_DEEMPHASIS_75_uS</constant>&nbsp;</entry>
>> +                   <entry>A de-emphasis of 75 uS is used.</entry>
>> +                 </row>
>> +               </tbody>
>> +             </entrytbl>
>> +
>> +       </row>
>> +          <row><entry></entry></row>
>> +        </tbody>
>> +      </tgroup>
>> +      </table>
>> +
>> +      </section>
>>      <section id="flash-controls">
>>        <title>Flash Control Reference</title>
>>
>> diff --git a/Documentation/DocBook/media/v4l/dev-rds.xml b/Documentation/DocBook/media/v4l/dev-rds.xml
>> index 38883a4..8188161 100644
>> --- a/Documentation/DocBook/media/v4l/dev-rds.xml
>> +++ b/Documentation/DocBook/media/v4l/dev-rds.xml
>> @@ -55,8 +55,9 @@ If the driver only passes RDS blocks without interpreting the data
>>  the <constant>V4L2_TUNER_CAP_RDS_BLOCK_IO</constant> flag has to be set. If the
>>  tuner is capable of handling RDS entities like program identification codes and radio
>>  text, the flag <constant>V4L2_TUNER_CAP_RDS_CONTROLS</constant> should be set,
>> -see <link linkend="writing-rds-data">Writing RDS data</link> and
>> -<link linkend="fm-tx-controls">FM Transmitter Control Reference</link>.</para>
>> +see <link linkend="writing-rds-data">Writing RDS data</link>,
>> +<link linkend="fm-tx-controls">FM Transmitter Control Reference</link>
>> +<link linkend="fm-rx-controls">FM Receiver Control Reference</link>.</para>
>>    </section>
>>
>>    <section  id="reading-rds-data">
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
>> index b17a7aa..2a8b44e 100644
>> --- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
>> @@ -258,6 +258,13 @@ These controls are described in <xref
>>  These controls are described in <xref
>>               linkend="fm-tx-controls" />.</entry>
>>         </row>
>> +          <row>
>> +            <entry><constant>V4L2_CTRL_CLASS_FM_RX</constant></entry>
>> +             <entry>0x9c0000</entry>
>> +             <entry>The class containing FM Receiver (FM RX) controls.
>> +These controls are described in <xref
>> +                 linkend="fm-rx-controls" />.</entry>
>> +           </row>
>>         <row>
>>           <entry><constant>V4L2_CTRL_CLASS_FLASH</constant></entry>
>>           <entry>0x9c0000</entry>
>>
>
> I'm missing the documentation for the new fm_band field!

I missed it :(. will add this in next patch set
>
> Regards,
>
>        Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards
Halli
